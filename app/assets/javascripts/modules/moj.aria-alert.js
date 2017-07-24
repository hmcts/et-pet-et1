// Focuses on aria alert if it's in the page for screen readers

var ariaAlert = (function() {

  var aria = {};

  aria.init = function() {
    var ariaAlert = document.getElementById('error-summary');
    if(ariaAlert) {
      ariaAlert.scrollIntoView();
      ariaAlert.focus();
    }
  };

  aria.init();

  return aria;
})();
