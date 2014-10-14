var jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
	polyfillDetail = require('./polyfills/polyfill.details'),
	reveal = require('./modules/moj.reveal'),
	revealPubSub = require('./modules/moj.reveal-pub-sub'),
	checkboxToggle = require('./modules/moj.checkbox-toggle'),
	selectedOption = require('./modules/moj.selected-option'),
	checkboxReveal = require('./modules/moj.checkbox-reveal'),
	formHintReveal = require('./modules/moj.reveal-hints'),
	nodeCloning = require('./modules/moj.node-cloning');


// init the revealPubSub.
revealPubSub.init();