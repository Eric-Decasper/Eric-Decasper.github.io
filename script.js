// Sidebar buttons: About / Experience / Projects swap the page content; the rest open links.
// The open view is kept in the URL (#projects etc.) so you can link straight to it.
document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.header-links button');
  const views = document.querySelectorAll('.view');
  const ids = [...views].map(v => v.id);

  function show(id) {
    if (!ids.includes(id)) id = 'about';
    views.forEach(v => { v.hidden = v.id !== id; });
    buttons.forEach(b => b.classList.toggle('current', b.dataset.view === id));
  }

  buttons.forEach(button => {
    button.addEventListener('click', () => {
      if (button.dataset.view) {
        history.replaceState(null, '', '#' + button.dataset.view);
        show(button.dataset.view);
        window.scrollTo(0, 0);
      } else if (button.dataset.link.startsWith('mailto:')) {
        window.location.href = button.dataset.link;
      } else {
        window.open(button.dataset.link, '_blank', 'noopener');
      }
    });
  });

  // Clicking a gallery photo opens it full size
  document.querySelectorAll('.gallery img').forEach(img => {
    img.addEventListener('click', () => window.open(img.src, '_blank'));
  });

  window.addEventListener('hashchange', () => show(location.hash.slice(1)));
  show(location.hash.slice(1));
});
