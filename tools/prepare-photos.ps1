# Makes web-sized copies of phone photos with all metadata (GPS location, camera info) stripped.
# Usage (from the portfolio folder):  powershell -File tools\prepare-photos.ps1
# Reads every .jpg/.jpeg/.png in photos-original\ (git-ignored) and writes photos-review\<same name>.jpg.
# Look them over, then move the ones you want into assets\img\ with descriptive names.
param(
  [string]$Source = "photos-original",
  [string]$Dest = "photos-review",
  [int]$MaxSide = 1600,
  [int]$Quality = 82
)
Add-Type -AssemblyName PresentationCore, WindowsBase

New-Item -ItemType Directory -Force $Dest | Out-Null
Get-ChildItem $Source -File | Where-Object { $_.Extension -match '^\.(jpe?g|png)$' } | ForEach-Object {
  $fs = [IO.File]::OpenRead($_.FullName)
  $frame = [Windows.Media.Imaging.BitmapDecoder]::Create($fs, 'PreservePixelFormat', 'OnLoad').Frames[0]

  # Phones store rotation as an EXIF flag; apply it so the photo is upright once metadata is removed
  $orientation = 1
  try { $o = $frame.Metadata.GetQuery('/app1/ifd/{ushort=274}'); if ($o) { $orientation = [int]$o } } catch {}
  $angle = switch ($orientation) { 3 { 180 } 6 { 90 } 8 { 270 } default { 0 } }

  $bmp = [Windows.Media.Imaging.BitmapSource]$frame
  if ($angle) { $bmp = New-Object Windows.Media.Imaging.TransformedBitmap($bmp, (New-Object Windows.Media.RotateTransform($angle))) }

  $scale = [Math]::Min(1.0, $MaxSide / [Math]::Max($bmp.PixelWidth, $bmp.PixelHeight))
  if ($scale -lt 1) { $bmp = New-Object Windows.Media.Imaging.TransformedBitmap($bmp, (New-Object Windows.Media.ScaleTransform($scale, $scale))) }

  $enc = New-Object Windows.Media.Imaging.JpegBitmapEncoder
  $enc.QualityLevel = $Quality
  $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))   # new frame = no metadata carried over
  $outPath = Join-Path $Dest ($_.BaseName + '.jpg')
  $out = [IO.File]::Create((Join-Path (Get-Location) $outPath))
  $enc.Save($out); $out.Close(); $fs.Close()
  '{0,-40} {1}x{2}  rotated {3}  -> {4} KB' -f $_.Name, $bmp.PixelWidth, $bmp.PixelHeight, $angle, [Math]::Round((Get-Item $outPath).Length / 1KB)
}
