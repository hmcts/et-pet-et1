var jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
  polyfillDetail = require('./polyfills/polyfill.details'),
  revealPubSub = require('./modules/moj.reveal-pub-sub'),
  selectedOption = require('./modules/moj.selected-option'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  removeMultiple = require('./modules/moj.remove-multiple'),
  stateIndicator = require('./modules/moj.state-indicator'),
  gaTracker = require('./modules/moj.ga-tracker'),
  sessionPrompt = window.sessionPrompt = require('./modules/moj.session-prompt');


revealPubSub.init();
