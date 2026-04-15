// Sidebar repliable par module.
// Chaque <p class="caption"> (Module 1, Module 2, …) devient cliquable et
// contrôle la visibilité du <ul> qui le suit. Au chargement, on ne laisse
// déplié que le module actif (celui dont l'UL porte la classe "current").
(function () {
  function init() {
    var nav = document.getElementById('bd-docs-nav');
    if (!nav) return;
    var captions = nav.querySelectorAll('p.caption');
    captions.forEach(function (caption) {
      var el = caption.nextElementSibling;
      while (el && el.tagName !== 'UL') el = el.nextElementSibling;
      if (!el) return;
      var ul = el;
      var isCurrent = ul.classList.contains('current');
      if (!isCurrent) {
        ul.classList.add('sbt-hidden');
        caption.classList.add('sbt-collapsed');
      }
      caption.addEventListener('click', function () {
        ul.classList.toggle('sbt-hidden');
        caption.classList.toggle('sbt-collapsed');
      });
    });
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
