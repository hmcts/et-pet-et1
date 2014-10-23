(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/index.js":[function(require,module,exports){
var jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
	polyfillDetail = require('./polyfills/polyfill.details'),
	revealPubSub = require('./modules/moj.reveal-pub-sub'),
	selectedOption = require('./modules/moj.selected-option'),
	formHintReveal = require('./modules/moj.reveal-hints'),
	nodeCloning = require('./modules/moj.node-cloning');

	revealPubSub.init();
},{"./modules/moj.jquery-pub-sub":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.jquery-pub-sub.js","./modules/moj.node-cloning":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.node-cloning.js","./modules/moj.reveal-hints":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.reveal-hints.js","./modules/moj.reveal-pub-sub":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.reveal-pub-sub.js","./modules/moj.selected-option":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.selected-option.js","./polyfills/polyfill.details":"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/polyfills/polyfill.details.js"}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.jquery-pub-sub.js":[function(require,module,exports){
/*! Tiny Pub/Sub - v0.7.0 - 2013-01-29
 * https://github.com/cowboy/jquery-tiny-pubsub
 * Copyright (c) 2013 "Cowboy" Ben Alman; Licensed MIT */
module.exports = (function(n) {

	var u = n({});
	n.subscribe = function() {
		u.on.apply(u, arguments);
	};
	n.unsubscribe = function() {
		u.off.apply(u, arguments);
	};
	n.publish = function() {
		u.trigger.apply(u, arguments);
	};
})(jQuery);
},{}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.node-cloning.js":[function(require,module,exports){
module.exports = (function() {
  var cloneSection = function(section) {
    var clone    = section.clone(),
        span     = $('span.index', clone),
        inputs   = $('input', clone);

    span.text(parseInt(span.text(), 10) + 1);
    inputs.val('');
    inputs.each(incrementAttrs);
    clone.insertAfter(section);
  }

  var incrementAttrs = function(_, input) {
    var oldId = input.id;
    var id    = oldId.replace(/_(\d+)_/, function(_, i) {
      return '_' + (parseInt(i, 10) + 1) + '_'
    });

    input = $(input);

    var name = input.attr('name').replace(/\[(\d+)\]/, function(_, i) {
      return '[' + (parseInt(i, 10) + 1) + ']'
    });

    input.attr('name', name);
    input.attr('id', id);
  }

  $('input[type=number].toggle').show().bind('change', function(event) {
    var selector = $(event.target).data('target');

    while($('.' + selector).size() < event.target.value) {
      cloneSection($('.' + selector).last());
    }

    while($('.' + selector).size() > event.target.value) {
      $('.' + selector).last().remove();
    }
  });
})();

},{}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.reveal-hints.js":[function(require,module,exports){
// Reveals hidden hint text

module.exports = (function() {
  $('.field_with_hint').each(function(i, field){
    var container = $(field),
      trigger = container.find('.hint-reveal');
    if(container.length){
      var content = container.find('.toggle-content');
      trigger.on('click', function(){
        content.toggle();
      });
    }
  });
})();
},{}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.reveal-pub-sub.js":[function(require,module,exports){
/**
 * Module dependancies:
 *   - jQuery
 *   - Tiny Pub / Sub
 *     https://github.com/cowboy/jquery-tiny-pubsub
 */

module.exports = (function () {
  'use strict';

  var revealPubSub = {
    settings: {}
  };

  /**
   * Object to store internal defaults
   * @type {Object}
   */
  var defaults = {
    // Activate ability to apply aria attributes to subscribers
    aria: true,

    // Apply aria-hidden attributes to subscribers when
    // as part of the bindSubscribe method
    // NOTE: settings.aria has to be set to true as well
    ariaHiddenOnInit: true,

    // Trigger the click event on any :checked publishers
    // after all the events are bound.
    // Useful when you need to reset the state of the page
    // after a form submit
    triggerPubsAfterBind: true
  };

  /**
   * Init the module
   */
  revealPubSub.init = function (options) {
    // Extend default with options and store as settings
    this.settings = $.extend({}, defaults, options);
    this.bindSubscribe();
    this.bindPublish();
    if(this.settings.triggerPubsAfterBind){
      this.triggerPublishers();
    }
  };

  /**
   * Bind a delegated click event on the containers
   * with publish elements.
   *
   * Container class: .reveal-publish-delegate
   * Publisher class: .reveal-publish-publisher
   *
   * Publisher attributes:
   * value:       The value will be used to determain if a subscriber should show/hide.
   *              The values can be any valid string.
   * data-target: The event name to subscribe to.
   *
   * Example:
   * <div class="reveal-publish-delegate">
        <input  name="sample" type="radio"
                class="reveal-publish-publisher"
                value="true"
                data-target="eventName" />

        <input  name="sample" type="radio"
                class="reveal-publish-publisher"
                value="false"
                data-target="eventName" />
      </div>
   */
  revealPubSub.bindPublish = function () {
    $('.reveal-publish-delegate').on('click pseudo-click', '.reveal-publish-publisher', function (e) {
      e.stopPropagation(); // stop nested elements to fire event twice
      var $el = $(e.target),
        elValue = $el[0].type === 'checkbox' ? $el[0].checked : $el.val();

      $.publish($el.data('target'), elValue);
    });
  };

  /**
   * Bind elements that subscribe to events.
   *
   * Subscriber class: .reveal-subscribe
   *
   * Subscriber attributes:
   * data-target:       The event name to subscibe to.
   * data-show-array:   An array of values that will show the element,
   *                    this corresponds to the puplisher value attribute
   *
   * Example:
   *  <div  class="reveal-subscribe"
            data-target="eventName"
            data-show-array="['true',....]">
              // Further HTML here
      </div>
   *
   * Optional:
   *   See defaults.aria & defaults.ariaHiddenOnInit
   *     - apply aria-hidden on init.
   *     - aplly aria-hidden when the state changes on an element.
   */
  revealPubSub.bindSubscribe = function () {
    var _this = this;

    $('.reveal-subscribe').is(function (idx, el) {
      var $el = $(el);

      // Applying Aria Hidden attributes
      if (_this.settings.aria && _this.settings.ariaHiddenOnInit) {
        _this.setAriaHiddenOnInit($el);
      }

      // Subscribe to the events
      $.subscribe($el.data('target'), function (event, val) {
        var ariaHidden;
        // $.inArray returns -1 if not in the array and the
        // array index if it is. Using ~ (Bitwise NOT) with !!
        // returns false for -1 and true for everything else.
        var isInArray = !!~$.inArray(val, $el.data('show-array'));

        // if reverse set to true then
        // reverse the boolean
        // if($el.data('reverse')){
        //   isInArray = !isInArray;
        // }

        if (isInArray) {
          $el.show();
          ariaHidden = false;
        } else {
          $el.hide();
          ariaHidden = true;
        }

        if (_this.settings.aria) {
          revealPubSub.setAriaHidden($el, ariaHidden);
        }
      });


    });
  };

  /**
   * Trigger all the click events on publishers that
   * are :checked. This is a feature. See: this.settings.triggerPubsAfterBind.
   * true by default.
   */
  revealPubSub.triggerPublishers = function () {
    $('.reveal-publish-publisher').is(function (idx, el) {
      var $el = $(this);
      if($el.is(':checked')){
        $el.trigger('pseudo-click');
      }
    });
  };

  /**
   * Apply aria-hidden attributes to subscibers
   * to reflect their state on init()
   * @param {[type]} $el jQuery element
   */
  revealPubSub.setAriaHiddenOnInit = function ($el) {
    if (!$el.is(':visible')) {
      revealPubSub.setAriaHidden($el, true);
      return;
    }
    revealPubSub.setAriaHidden($el, false);
  };

  /**
   * Util method that changes the aria-hidden
   * attribute as required
   * @param {[type]} $el  jQuery element
   * @param {[type]} bool the aria-hidden attribute will be set to this value
   */
  revealPubSub.setAriaHidden = function ($el, bool) {
    return bool ? $el.attr('aria-hidden', true) : $el.attr('aria-hidden', false);
  };

  /**
   * Return the module
   * NOTE: Call the init method outside passing any
   *       settings to override defaults
   */
  return revealPubSub;
}());
},{}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/modules/moj.selected-option.js":[function(require,module,exports){
/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
  $('.options').each(function(i, container){
    var blocklabels = $(container).find('.block-label'),
      labels = blocklabels.find('label');

    labels.each(function(i, el){
      var label = $(el),
        input = label.find('input');
      input.on('change', function(){
        var checked = input.is(':checked');
        labels.removeClass('selected');
        label.toggleClass('selected', checked);
      });
    });
  });
})();
},{}],"/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/polyfills/polyfill.details.js":[function(require,module,exports){
module.exports = (function () {
 /*! http://mths.be/details v0.1.0 by @mathias | includes http://mths.be/noselect v1.0.3 */
;(function(a,f){var e=f.fn,d,c=Object.prototype.toString.call(window.opera)=='[object Opera]',g=(function(l){var j=l.createElement('details'),i,h,k;if(!('open' in j)){return false}h=l.body||(function(){var m=l.documentElement;i=true;return m.insertBefore(l.createElement('body'),m.firstElementChild||m.firstChild)}());j.innerHTML='<summary>a</summary>b';j.style.display='block';h.appendChild(j);k=j.offsetHeight;j.open=true;k=k!=j.offsetHeight;h.removeChild(j);if(i){h.parentNode.removeChild(h)}return k}(a)),b=function(i,l,k,h){var j=i.prop('open'),m=j&&h||!j&&!h;if(m){i.removeClass('open').prop('open',false).triggerHandler('close.details');l.attr('aria-expanded',false);k.hide()}else{i.addClass('open').prop('open',true).triggerHandler('open.details');l.attr('aria-expanded',true);k.show()}};e.noSelect=function(){var h='none';return this.bind('selectstart dragstart mousedown',function(){return false}).css({MozUserSelect:h,msUserSelect:h,webkitUserSelect:h,userSelect:h})};if(g){d=e.details=function(){return this.each(function(){var i=f(this),h=f('summary',i).first();h.attr({role:'button','aria-expanded':i.prop('open')}).on('click',function(){var j=i.prop('open');h.attr('aria-expanded',!j);i.triggerHandler((j?'close':'open')+'.details')})})};d.support=g}else{d=e.details=function(){return this.each(function(){var h=f(this),j=f('summary',h).first(),i=h.children(':not(summary)'),k=h.contents(':not(summary)');if(!j.length){j=f('<summary>').text('Details').prependTo(h)}if(i.length!=k.length){k.filter(function(){return this.nodeType==3&&/[^ \t\n\f\r]/.test(this.data)}).wrap('<span>');i=h.children(':not(summary)')}h.prop('open',typeof h.attr('open')=='string');b(h,j,i);j.attr('role','button').noSelect().prop('tabIndex',0).on('click',function(){j.focus();b(h,j,i,true)}).keyup(function(l){if(32==l.keyCode||(13==l.keyCode&&!c)){l.preventDefault();j.click()}})})};d.support=g}}(document,jQuery));
})();

$(function () {
  $('details').details();
});
},{}]},{},["/Users/davidplews/moj_projects/atetv2/app/assets/javascripts/index.js"]);
