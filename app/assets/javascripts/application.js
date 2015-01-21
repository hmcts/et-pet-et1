var gaTracker = window.gaTracker = require('./modules/moj.ga-tracking'),
  jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
  polyfillDetail = require('./polyfills/polyfill.details'),
  revealPubSub = require('./modules/moj.reveal-pub-sub'),
  selectedOption = require('./modules/moj.selected-option'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  removeMultiple = require('./modules/moj.remove-multiple'),
  stateIndicator = require('./modules/moj.state-indicator'),
  mobileNav = require('./modules/moj.mobile-nav'),
  sessionPrompt = window.sessionPrompt = require('./modules/moj.session-prompt');


revealPubSub.init();
