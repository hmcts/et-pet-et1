var jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
  polyfillDetail = require('./polyfills/polyfill.details'),
  revealPubSub = require('./modules/moj.reveal-pub-sub'),
  selectedOption = require('./modules/moj.selected-option'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  removeMultiple = require('./modules/moj.remove-multiple'),
  sessionPrompt = require('./modules/moj.session-prompt'),
  cheetJS = require('cheet.js');

cheetJS('e x p i r e 1 2 3', function () {
  $('#logo img').fadeOut().fadeIn();
  sessionPrompt.init({
    FIVE_MINUTES: 90000,
    FIFTY_FIVE_MINUTES: 5000
  });
});

revealPubSub.init();
