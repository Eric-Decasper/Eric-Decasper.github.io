# Eric Decasper: portfolio website

Plain HTML, CSS and JavaScript, no build step. Layout is based on Luis Scheibe's site
(github.com/luisscheibe9-git/luisscheibe9-git.github.io): name, photo and buttons on the left, content on the right.
The About / Experience / Projects buttons swap the `.view` blocks in `index.html`, and the open view is kept in the URL
(`#experience`, `#projects`) so you can link to it directly. On phones the two columns stack.

Type is IBM Plex Sans (dates in IBM Plex Mono). The accent color is `--accent` at the top of `styles.css`.

## Files
| Path | What it is |
|---|---|
| `index.html` | All page content. Edit the text here |
| `styles.css` | Styling |
| `script.js` | Button switching and click-to-enlarge photos |
| `assets/img/` | Images (headshot goes in as `profile.jpg`) |
| `assets/Eric_Decasper_Resume.pdf` | Resume copy **with the phone number removed** |
| `assets/Eric_Decasper_Voliro_Reference_Letter.pdf` | Voliro reference letter (home address and direct phone numbers removed) |
| `tools/prepare-photos.ps1` | Shrinks phone photos and strips GPS/camera metadata before they go online |

Content comes from `Downloads\MechEResumeEricDecasper.pdf` (Oct 5, 2026 version).

## Previewing locally
From this folder run `python -m http.server 5500 --bind 127.0.0.1`, then open http://localhost:5500.

## Adding photos
1. Put the originals in `photos-original\` (git-ignored, never published).
2. Run `powershell -File tools\prepare-photos.ps1`. Cleaned copies land in `photos-review\`.
3. Move the keepers into `assets\img\` with descriptive names, and add a gallery under the right entry in `index.html`:
   ```html
   <div class="gallery">
     <figure><img src="assets/img/wmc-test-stand.jpg" alt="End-of-line motor test stand" loading="lazy"><figcaption>End-of-line test stand</figcaption></figure>
   </div>
   ```
   Use `class="gallery cad"` for CAD renders and PCB screenshots so they aren't cropped.

Check with Western Magnetics and Voliro before posting photos of their hardware or facilities.

## Before publishing
- [x] Headshot (`assets/img/profile.jpg`, cropped to 600 px square, metadata stripped).
- [x] Resume PDF without the phone number (`assets/Eric_Decasper_Resume.pdf`, exported from a copy of `Downloads\EricDecasperResume.docx`, Oct 21 version, with author/title metadata cleaned). Redo this whenever the resume changes.
- [ ] GitHub button: add once there's a GitHub account to link.
- [ ] Photos for at least the test stand, the Voliro payloads and the scanning arm.

## Publishing (GitHub Pages)
Create a public repo named `<your-github-username>.github.io`, push this folder to `main`, and the site goes live at
`https://<your-github-username>.github.io` within a minute or two. Every later push to `main` updates it.
