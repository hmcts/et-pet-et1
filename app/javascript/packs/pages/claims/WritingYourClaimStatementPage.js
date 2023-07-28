function setupClickListener() {
  document.addEventListener('click', function (e) {
    if (!e.target.matches('a[data-scroll-top]')) {
      return;
    }
    e.preventDefault();
    ScrollToTop();
  });
}
function ScrollToTop() {
  window.scrollTo({ top: 0 });
}

export default function WritingYourClaimStatementPage() {
  setupClickListener();
};
