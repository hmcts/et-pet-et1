(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var jqueryPubSub = require('./modules/moj.jquery-pub-sub'),
  polyfillDetail = require('./polyfills/polyfill.details'),
  revealPubSub = require('./modules/moj.reveal-pub-sub'),
  selectedOption = require('./modules/moj.selected-option'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  removeMultiple = require('./modules/moj.remove-multiple'),
  stateIndicator = require('./modules/moj.state-indicator'),
  sessionPrompt = window.sessionPrompt = require('./modules/moj.session-prompt');


revealPubSub.init();

},{"./modules/moj.jquery-pub-sub":2,"./modules/moj.remove-multiple":3,"./modules/moj.reveal-hints":4,"./modules/moj.reveal-pub-sub":5,"./modules/moj.selected-option":6,"./modules/moj.session-prompt":7,"./modules/moj.state-indicator":8,"./polyfills/polyfill.details":9}],2:[function(require,module,exports){
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
},{}],3:[function(require,module,exports){
module.exports = (function() {
  'use strict';

  var removeMultiple = removeMultiple || {},
    container = $('.multiples'),
    multiples = container.find('.multiple');

  removeMultiple.init = function() {

    if(multiples.length <= 1) {
      multiples.find('.remove-multiple').hide();
    } else {
      multiples.each(function(i, el) {
        var checkbox = $(el).find('.destroy-checkbox');
        //bind the remove method
        removeMultiple.bindRemoveButton(el, checkbox);
        // hide if already checked
        el.style.display = checkbox.is(':checked') ? 'none' : 'block';
      });
    }
    //update the counter
    removeMultiple.updateCount();
  };

  removeMultiple.bindRemoveButton = function(el, checkbox) {
    var link = $(el).find('.remove-multiple');

    //hide on click and check the hidden checkbox
    link.on('click', function(){
      el.style.display = 'none';

      checkbox.prop('checked', true);
      removeMultiple.updateCount();
    });
  };

  removeMultiple.updateCount = function() {
    var visibles = multiples.filter(':visible');

    // only update the counter on visible multiples
    visibles.each(function(i, el) {
      var section = $(el),
        count = i + 2;
      // update the string for the user
      replaceNumber(section.find('legend:first'), count);
    });

    function replaceNumber(el, count) {
      return $(el).text(function() {
        return $(el).text().replace(/\d+/g, count);
      });
    }
  };

  removeMultiple.init();

  return removeMultiple;

})();

},{}],4:[function(require,module,exports){
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
},{}],5:[function(require,module,exports){
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
    triggerPubsAfterBind: true,

    // The character used to as delimiter
    // between event names in data-show-array
    dataShowArrayDelimiter: ' '
  };

  /**
   * Init the module
   */
  revealPubSub.init = function (options) {
    // Extend default with options and store as settings
    this.settings = $.extend({}, defaults, options);
    this.bindSubscribe();
    this.bindPublish();
    if (this.settings.triggerPubsAfterBind) {
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
        elValue = $el[0].type === 'checkbox' ? $el[0].checked.toString() : $el.val();

      $.publish($el.attr('data-target'), elValue);
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
            data-show-array="true|..]">
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
      $.subscribe($el.attr('data-target'), function (event, val) {
        var ariaHidden;
        var isInArray = $.inArray(val, $el.attr('data-show-array').split(_this.settings.dataShowArrayDelimiter));

        if (isInArray !== -1) {
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
      if ($el.is(':checked')) {
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

},{}],6:[function(require,module,exports){
/* Toggles selected option class, assumes the following structure
* .options > .block-label + .block-label > label > input[:radio || :checkbox]
*/

module.exports = (function() {
  'use strict';

  var selectedOption = {},
    options = $('.options, .check_boxes'),
    change_class = 'selected',
    focusblur_class = 'add-focus';

  selectedOption.init = function() {
    options.each(function(i, container){
      var input_group = $(container).find('.block-label, .slim-label');

      selectedOption.bindInputEvents(input_group);

    });
  };

  selectedOption.bindInputEvents = function(input_group) {
    input_group.each(function(i, blocklabel){
      var container = $(blocklabel),
        siblings = container.siblings().find('label'),
        input = container.find('input'),
        is_radio = input.is(':radio'),
        label = container.find('label');

      input.on('change', function(){
        var is_checked = input.is(':checked');

        if(is_checked && is_radio) {
          siblings.removeClass(change_class);
        }

        label.toggleClass(change_class, is_checked);

      })
      .on('focus', function(){
        label.addClass(focusblur_class);
      })
      .on('blur', function(){
        label.removeClass(focusblur_class);
      })
      .change();
    });
  };

  selectedOption.init();

  return selectedOption;

})();

},{}],7:[function(require,module,exports){
// Manages session timeout & displays prompt prior to session expiry
module.exports = (function () {

  var settings = {
    SECOND: 1000
  };
  settings.MINUTE = 60 * settings.SECOND;
  settings.FIVE_MINUTES = 5 * settings.MINUTE;
  settings.FIFTY_FIVE_MINUTES = 55 * settings.MINUTE;

  var sessionPrompt = {

    timerRef: null,

    init: function (options) {
      settings = $.extend(settings, options);
      this.counter = settings.FIVE_MINUTES;
      this.updateTimeLeftOnPrompt(this.counter);
      this.setPromptExtendSessionClickEvent();
      this.startSessionTimer();
    },

    startSessionTimer: function () {
      setTimeout($.proxy(this.timeoutPrompt, this), settings.FIFTY_FIVE_MINUTES);
    },

    setPromptExtendSessionClickEvent: function () {
      $("#session_prompt_continue_btn").unbind().on("click", $.proxy(this.refreshSession, this));
    },

    timeoutPrompt: function () {
      this.timerRef = setInterval($.proxy(this.promptUpdate, this), settings.SECOND);
      this.togglePromptVisibility();
    },

    promptUpdate: function () {
      if (this.counter === 0) {
        this.expireSession();
      } else {
        this.counter -= settings.SECOND;
        this.updateTimeLeftOnPrompt(this.counter);
      }
    },

    togglePromptVisibility: function () {
      $("#session_prompt").toggleClass("hidden");
    },

    updateTimeLeftOnPrompt: function (timeInMillis) {
      var seconds = timeInMillis / settings.SECOND;
      var mins = Math.floor(seconds / 60);
      var secs = seconds % 60;
      var time = (mins === 0) ? secs : (mins + ":" + this.padSeconds(secs));
      $('#session_prompt_time_left').text(time);
    },

    padSeconds: function (secs) {
      return ((secs + "").length === 1) ? "0" + secs : secs;
    },

    expireSession: function () {
      location.href = location.protocol + "//" + location.host + "/application/session-expired";
    },

    refreshSession: function () {
      clearInterval(this.timerRef);
      $.ajax({
        url: "/application/refresh-session"
      }).done(
        $.proxy(function () {
          this.togglePromptVisibility();
          this.init();
        }, this)
      );
    }
  };


  var isClaimPath = function () {
    return !!location.pathname.match(/^\/apply\/.*/);
  };

  if (isClaimPath()) {
    sessionPrompt.init();
  }

  return sessionPrompt;

})();

},{}],8:[function(require,module,exports){
// state indicator
// This requires CSS media queries that
// update the z-index on div.state-indicator.
// The element will be created by the JS.
module.exports = (function () {

  // Debounce
  // http://davidwalsh.name/function-debounce
  var debounce = function (func, wait, immediate) {
    var timeout;
    return function () {
      var context = this,
        args = arguments;
      var later = function () {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    };
  };

  // setting some defaults
  var stateIndicator = {
    states: {
      8001: 'mobile',
      8002: 'tablet',
      8003: 'desktop'
    },
    baseState: 'desktop'
  };

  // Just a little shorter to write
  var si = stateIndicator;

  si.init = function () {
    // create the element
    si.__createElement();

    // run the handler manually at start
    si.__handleOrientation();

    si.bindToResize();
  };

  // Bind to the resize / onorientationchange event
  si.bindToResize = function () {
    si.__lastDeviceState = si.getDeviceState();
    var _supports_orientation = "onorientationchange" in window;
    var _orientation_event = _supports_orientation ? "orientationchange" : "resize";

    if (window.addEventListener) {
      window.addEventListener(_orientation_event, si.__handleOrientation, false);
    } else if (window.attachEvent) {
      window.attachEvent(_orientation_event, si.__handleOrientation);
    } else {
      window[_orientation_event] = si.__handleOrientation;
    }
  };

  // Return the current state based on the
  // z-index for the hidden element
  // defaults to si.baseState
  si.getDeviceState = function () {
    var index = parseInt(si.$indicator.css('z-index'), 10);
    return si.states[index] || si.baseState;
  };

  si.__handleOrientation = debounce(function () {
    si.__state = si.getDeviceState();

    if (si.__state !== si.__lastDeviceState) {
      // Save the new state as current

      // Publishes two events:
      // - A state change occured (/device/change/)
      // - The to / from direction (/device/move/[fromState]/to/[toState])
      // - The actual state will be passed into the callback
      if ($.publish) {
        $.publish('/device/change/', [si.__state]);
        $.publish('/device/move/' + si.__lastDeviceState + '/to/' + si.__state + '/', [si.__state]);
      }
      si.__lastDeviceState = si.__state;
    }
  }, 20);

  si.__createElement = function () {
    // Create the state-indicator element
    si.indicator = document.createElement('div');
    si.indicator.className = 'state-indicator';
    document.body.appendChild(si.indicator);
    si.$indicator = $(si.indicator);
  };

  ////////////////
  // Init steps //
  ////////////////
  si.init();

  return stateIndicator;
})();

},{}],9:[function(require,module,exports){
module.exports = (function () {
 /*! http://mths.be/details v0.1.0 by @mathias | includes http://mths.be/noselect v1.0.3 */
;(function(a,f){var e=f.fn,d,c=Object.prototype.toString.call(window.opera)=='[object Opera]',g=(function(l){var j=l.createElement('details'),i,h,k;if(!('open' in j)){return false}h=l.body||(function(){var m=l.documentElement;i=true;return m.insertBefore(l.createElement('body'),m.firstElementChild||m.firstChild)}());j.innerHTML='<summary>a</summary>b';j.style.display='block';h.appendChild(j);k=j.offsetHeight;j.open=true;k=k!=j.offsetHeight;h.removeChild(j);if(i){h.parentNode.removeChild(h)}return k}(a)),b=function(i,l,k,h){var j=i.prop('open'),m=j&&h||!j&&!h;if(m){i.removeClass('open').prop('open',false).triggerHandler('close.details');l.attr('aria-expanded',false);k.hide()}else{i.addClass('open').prop('open',true).triggerHandler('open.details');l.attr('aria-expanded',true);k.show()}};e.noSelect=function(){var h='none';return this.bind('selectstart dragstart mousedown',function(){return false}).css({MozUserSelect:h,msUserSelect:h,webkitUserSelect:h,userSelect:h})};if(g){d=e.details=function(){return this.each(function(){var i=f(this),h=f('summary',i).first();h.attr({role:'button','aria-expanded':i.prop('open')}).on('click',function(){var j=i.prop('open');h.attr('aria-expanded',!j);i.triggerHandler((j?'close':'open')+'.details')})})};d.support=g}else{d=e.details=function(){return this.each(function(){var h=f(this),j=f('summary',h).first(),i=h.children(':not(summary)'),k=h.contents(':not(summary)');if(!j.length){j=f('<summary>').text('Details').prependTo(h)}if(i.length!=k.length){k.filter(function(){return this.nodeType==3&&/[^ \t\n\f\r]/.test(this.data)}).wrap('<span>');i=h.children(':not(summary)')}h.prop('open',typeof h.attr('open')=='string');b(h,j,i);j.attr('role','button').noSelect().prop('tabIndex',0).on('click',function(){j.focus();b(h,j,i,true)}).keyup(function(l){if(32==l.keyCode||(13==l.keyCode&&!c)){l.preventDefault();j.click()}})})};d.support=g}}(document,jQuery));
})();

$(function () {
  $('details').details();
});
},{}]},{},[1])
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvZGF2aWRwbGV3cy9tb2pfcHJvamVjdHMvYXRldHYyL2FwcC9hc3NldHMvamF2YXNjcmlwdHMvX3N0cmVhbV8xLmpzIiwiL1VzZXJzL2RhdmlkcGxld3MvbW9qX3Byb2plY3RzL2F0ZXR2Mi9hcHAvYXNzZXRzL2phdmFzY3JpcHRzL21vZHVsZXMvbW9qLmpxdWVyeS1wdWItc3ViLmpzIiwiL1VzZXJzL2RhdmlkcGxld3MvbW9qX3Byb2plY3RzL2F0ZXR2Mi9hcHAvYXNzZXRzL2phdmFzY3JpcHRzL21vZHVsZXMvbW9qLnJlbW92ZS1tdWx0aXBsZS5qcyIsIi9Vc2Vycy9kYXZpZHBsZXdzL21val9wcm9qZWN0cy9hdGV0djIvYXBwL2Fzc2V0cy9qYXZhc2NyaXB0cy9tb2R1bGVzL21vai5yZXZlYWwtaGludHMuanMiLCIvVXNlcnMvZGF2aWRwbGV3cy9tb2pfcHJvamVjdHMvYXRldHYyL2FwcC9hc3NldHMvamF2YXNjcmlwdHMvbW9kdWxlcy9tb2oucmV2ZWFsLXB1Yi1zdWIuanMiLCIvVXNlcnMvZGF2aWRwbGV3cy9tb2pfcHJvamVjdHMvYXRldHYyL2FwcC9hc3NldHMvamF2YXNjcmlwdHMvbW9kdWxlcy9tb2ouc2VsZWN0ZWQtb3B0aW9uLmpzIiwiL1VzZXJzL2RhdmlkcGxld3MvbW9qX3Byb2plY3RzL2F0ZXR2Mi9hcHAvYXNzZXRzL2phdmFzY3JpcHRzL21vZHVsZXMvbW9qLnNlc3Npb24tcHJvbXB0LmpzIiwiL1VzZXJzL2RhdmlkcGxld3MvbW9qX3Byb2plY3RzL2F0ZXR2Mi9hcHAvYXNzZXRzL2phdmFzY3JpcHRzL21vZHVsZXMvbW9qLnN0YXRlLWluZGljYXRvci5qcyIsIi9Vc2Vycy9kYXZpZHBsZXdzL21val9wcm9qZWN0cy9hdGV0djIvYXBwL2Fzc2V0cy9qYXZhc2NyaXB0cy9wb2x5ZmlsbHMvcG9seWZpbGwuZGV0YWlscy5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0FBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUNYQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUNmQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDM0RBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDYkE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ3pMQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUN0REE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ3pGQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ3ZHQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBIiwiZmlsZSI6ImdlbmVyYXRlZC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsInZhciBqcXVlcnlQdWJTdWIgPSByZXF1aXJlKCcuL21vZHVsZXMvbW9qLmpxdWVyeS1wdWItc3ViJyksXG4gIHBvbHlmaWxsRGV0YWlsID0gcmVxdWlyZSgnLi9wb2x5ZmlsbHMvcG9seWZpbGwuZGV0YWlscycpLFxuICByZXZlYWxQdWJTdWIgPSByZXF1aXJlKCcuL21vZHVsZXMvbW9qLnJldmVhbC1wdWItc3ViJyksXG4gIHNlbGVjdGVkT3B0aW9uID0gcmVxdWlyZSgnLi9tb2R1bGVzL21vai5zZWxlY3RlZC1vcHRpb24nKSxcbiAgZm9ybUhpbnRSZXZlYWwgPSByZXF1aXJlKCcuL21vZHVsZXMvbW9qLnJldmVhbC1oaW50cycpLFxuICByZW1vdmVNdWx0aXBsZSA9IHJlcXVpcmUoJy4vbW9kdWxlcy9tb2oucmVtb3ZlLW11bHRpcGxlJyksXG4gIHN0YXRlSW5kaWNhdG9yID0gcmVxdWlyZSgnLi9tb2R1bGVzL21vai5zdGF0ZS1pbmRpY2F0b3InKSxcbiAgc2Vzc2lvblByb21wdCA9IHdpbmRvdy5zZXNzaW9uUHJvbXB0ID0gcmVxdWlyZSgnLi9tb2R1bGVzL21vai5zZXNzaW9uLXByb21wdCcpO1xuXG5cbnJldmVhbFB1YlN1Yi5pbml0KCk7XG4iLCIvKiEgVGlueSBQdWIvU3ViIC0gdjAuNy4wIC0gMjAxMy0wMS0yOVxuICogaHR0cHM6Ly9naXRodWIuY29tL2Nvd2JveS9qcXVlcnktdGlueS1wdWJzdWJcbiAqIENvcHlyaWdodCAoYykgMjAxMyBcIkNvd2JveVwiIEJlbiBBbG1hbjsgTGljZW5zZWQgTUlUICovXG5tb2R1bGUuZXhwb3J0cyA9IChmdW5jdGlvbihuKSB7XG5cblx0dmFyIHUgPSBuKHt9KTtcblx0bi5zdWJzY3JpYmUgPSBmdW5jdGlvbigpIHtcblx0XHR1Lm9uLmFwcGx5KHUsIGFyZ3VtZW50cyk7XG5cdH07XG5cdG4udW5zdWJzY3JpYmUgPSBmdW5jdGlvbigpIHtcblx0XHR1Lm9mZi5hcHBseSh1LCBhcmd1bWVudHMpO1xuXHR9O1xuXHRuLnB1Ymxpc2ggPSBmdW5jdGlvbigpIHtcblx0XHR1LnRyaWdnZXIuYXBwbHkodSwgYXJndW1lbnRzKTtcblx0fTtcbn0pKGpRdWVyeSk7IiwibW9kdWxlLmV4cG9ydHMgPSAoZnVuY3Rpb24oKSB7XG4gICd1c2Ugc3RyaWN0JztcblxuICB2YXIgcmVtb3ZlTXVsdGlwbGUgPSByZW1vdmVNdWx0aXBsZSB8fCB7fSxcbiAgICBjb250YWluZXIgPSAkKCcubXVsdGlwbGVzJyksXG4gICAgbXVsdGlwbGVzID0gY29udGFpbmVyLmZpbmQoJy5tdWx0aXBsZScpO1xuXG4gIHJlbW92ZU11bHRpcGxlLmluaXQgPSBmdW5jdGlvbigpIHtcblxuICAgIGlmKG11bHRpcGxlcy5sZW5ndGggPD0gMSkge1xuICAgICAgbXVsdGlwbGVzLmZpbmQoJy5yZW1vdmUtbXVsdGlwbGUnKS5oaWRlKCk7XG4gICAgfSBlbHNlIHtcbiAgICAgIG11bHRpcGxlcy5lYWNoKGZ1bmN0aW9uKGksIGVsKSB7XG4gICAgICAgIHZhciBjaGVja2JveCA9ICQoZWwpLmZpbmQoJy5kZXN0cm95LWNoZWNrYm94Jyk7XG4gICAgICAgIC8vYmluZCB0aGUgcmVtb3ZlIG1ldGhvZFxuICAgICAgICByZW1vdmVNdWx0aXBsZS5iaW5kUmVtb3ZlQnV0dG9uKGVsLCBjaGVja2JveCk7XG4gICAgICAgIC8vIGhpZGUgaWYgYWxyZWFkeSBjaGVja2VkXG4gICAgICAgIGVsLnN0eWxlLmRpc3BsYXkgPSBjaGVja2JveC5pcygnOmNoZWNrZWQnKSA/ICdub25lJyA6ICdibG9jayc7XG4gICAgICB9KTtcbiAgICB9XG4gICAgLy91cGRhdGUgdGhlIGNvdW50ZXJcbiAgICByZW1vdmVNdWx0aXBsZS51cGRhdGVDb3VudCgpO1xuICB9O1xuXG4gIHJlbW92ZU11bHRpcGxlLmJpbmRSZW1vdmVCdXR0b24gPSBmdW5jdGlvbihlbCwgY2hlY2tib3gpIHtcbiAgICB2YXIgbGluayA9ICQoZWwpLmZpbmQoJy5yZW1vdmUtbXVsdGlwbGUnKTtcblxuICAgIC8vaGlkZSBvbiBjbGljayBhbmQgY2hlY2sgdGhlIGhpZGRlbiBjaGVja2JveFxuICAgIGxpbmsub24oJ2NsaWNrJywgZnVuY3Rpb24oKXtcbiAgICAgIGVsLnN0eWxlLmRpc3BsYXkgPSAnbm9uZSc7XG5cbiAgICAgIGNoZWNrYm94LnByb3AoJ2NoZWNrZWQnLCB0cnVlKTtcbiAgICAgIHJlbW92ZU11bHRpcGxlLnVwZGF0ZUNvdW50KCk7XG4gICAgfSk7XG4gIH07XG5cbiAgcmVtb3ZlTXVsdGlwbGUudXBkYXRlQ291bnQgPSBmdW5jdGlvbigpIHtcbiAgICB2YXIgdmlzaWJsZXMgPSBtdWx0aXBsZXMuZmlsdGVyKCc6dmlzaWJsZScpO1xuXG4gICAgLy8gb25seSB1cGRhdGUgdGhlIGNvdW50ZXIgb24gdmlzaWJsZSBtdWx0aXBsZXNcbiAgICB2aXNpYmxlcy5lYWNoKGZ1bmN0aW9uKGksIGVsKSB7XG4gICAgICB2YXIgc2VjdGlvbiA9ICQoZWwpLFxuICAgICAgICBjb3VudCA9IGkgKyAyO1xuICAgICAgLy8gdXBkYXRlIHRoZSBzdHJpbmcgZm9yIHRoZSB1c2VyXG4gICAgICByZXBsYWNlTnVtYmVyKHNlY3Rpb24uZmluZCgnbGVnZW5kOmZpcnN0JyksIGNvdW50KTtcbiAgICB9KTtcblxuICAgIGZ1bmN0aW9uIHJlcGxhY2VOdW1iZXIoZWwsIGNvdW50KSB7XG4gICAgICByZXR1cm4gJChlbCkudGV4dChmdW5jdGlvbigpIHtcbiAgICAgICAgcmV0dXJuICQoZWwpLnRleHQoKS5yZXBsYWNlKC9cXGQrL2csIGNvdW50KTtcbiAgICAgIH0pO1xuICAgIH1cbiAgfTtcblxuICByZW1vdmVNdWx0aXBsZS5pbml0KCk7XG5cbiAgcmV0dXJuIHJlbW92ZU11bHRpcGxlO1xuXG59KSgpO1xuIiwiLy8gUmV2ZWFscyBoaWRkZW4gaGludCB0ZXh0XG5cbm1vZHVsZS5leHBvcnRzID0gKGZ1bmN0aW9uKCkge1xuICAkKCcuZmllbGRfd2l0aF9oaW50JykuZWFjaChmdW5jdGlvbihpLCBmaWVsZCl7XG4gICAgdmFyIGNvbnRhaW5lciA9ICQoZmllbGQpLFxuICAgICAgdHJpZ2dlciA9IGNvbnRhaW5lci5maW5kKCcuaGludC1yZXZlYWwnKTtcbiAgICBpZihjb250YWluZXIubGVuZ3RoKXtcbiAgICAgIHZhciBjb250ZW50ID0gY29udGFpbmVyLmZpbmQoJy50b2dnbGUtY29udGVudCcpO1xuICAgICAgdHJpZ2dlci5vbignY2xpY2snLCBmdW5jdGlvbigpe1xuICAgICAgICBjb250ZW50LnRvZ2dsZSgpO1xuICAgICAgfSk7XG4gICAgfVxuICB9KTtcbn0pKCk7IiwiLyoqXG4gKiBNb2R1bGUgZGVwZW5kYW5jaWVzOlxuICogICAtIGpRdWVyeVxuICogICAtIFRpbnkgUHViIC8gU3ViXG4gKiAgICAgaHR0cHM6Ly9naXRodWIuY29tL2Nvd2JveS9qcXVlcnktdGlueS1wdWJzdWJcbiAqL1xuXG5tb2R1bGUuZXhwb3J0cyA9IChmdW5jdGlvbiAoKSB7XG4gICd1c2Ugc3RyaWN0JztcblxuICB2YXIgcmV2ZWFsUHViU3ViID0ge1xuICAgIHNldHRpbmdzOiB7fVxuICB9O1xuXG4gIC8qKlxuICAgKiBPYmplY3QgdG8gc3RvcmUgaW50ZXJuYWwgZGVmYXVsdHNcbiAgICogQHR5cGUge09iamVjdH1cbiAgICovXG4gIHZhciBkZWZhdWx0cyA9IHtcbiAgICAvLyBBY3RpdmF0ZSBhYmlsaXR5IHRvIGFwcGx5IGFyaWEgYXR0cmlidXRlcyB0byBzdWJzY3JpYmVyc1xuICAgIGFyaWE6IHRydWUsXG5cbiAgICAvLyBBcHBseSBhcmlhLWhpZGRlbiBhdHRyaWJ1dGVzIHRvIHN1YnNjcmliZXJzIHdoZW5cbiAgICAvLyBhcyBwYXJ0IG9mIHRoZSBiaW5kU3Vic2NyaWJlIG1ldGhvZFxuICAgIC8vIE5PVEU6IHNldHRpbmdzLmFyaWEgaGFzIHRvIGJlIHNldCB0byB0cnVlIGFzIHdlbGxcbiAgICBhcmlhSGlkZGVuT25Jbml0OiB0cnVlLFxuXG4gICAgLy8gVHJpZ2dlciB0aGUgY2xpY2sgZXZlbnQgb24gYW55IDpjaGVja2VkIHB1Ymxpc2hlcnNcbiAgICAvLyBhZnRlciBhbGwgdGhlIGV2ZW50cyBhcmUgYm91bmQuXG4gICAgLy8gVXNlZnVsIHdoZW4geW91IG5lZWQgdG8gcmVzZXQgdGhlIHN0YXRlIG9mIHRoZSBwYWdlXG4gICAgLy8gYWZ0ZXIgYSBmb3JtIHN1Ym1pdFxuICAgIHRyaWdnZXJQdWJzQWZ0ZXJCaW5kOiB0cnVlLFxuXG4gICAgLy8gVGhlIGNoYXJhY3RlciB1c2VkIHRvIGFzIGRlbGltaXRlclxuICAgIC8vIGJldHdlZW4gZXZlbnQgbmFtZXMgaW4gZGF0YS1zaG93LWFycmF5XG4gICAgZGF0YVNob3dBcnJheURlbGltaXRlcjogJyAnXG4gIH07XG5cbiAgLyoqXG4gICAqIEluaXQgdGhlIG1vZHVsZVxuICAgKi9cbiAgcmV2ZWFsUHViU3ViLmluaXQgPSBmdW5jdGlvbiAob3B0aW9ucykge1xuICAgIC8vIEV4dGVuZCBkZWZhdWx0IHdpdGggb3B0aW9ucyBhbmQgc3RvcmUgYXMgc2V0dGluZ3NcbiAgICB0aGlzLnNldHRpbmdzID0gJC5leHRlbmQoe30sIGRlZmF1bHRzLCBvcHRpb25zKTtcbiAgICB0aGlzLmJpbmRTdWJzY3JpYmUoKTtcbiAgICB0aGlzLmJpbmRQdWJsaXNoKCk7XG4gICAgaWYgKHRoaXMuc2V0dGluZ3MudHJpZ2dlclB1YnNBZnRlckJpbmQpIHtcbiAgICAgIHRoaXMudHJpZ2dlclB1Ymxpc2hlcnMoKTtcbiAgICB9XG4gIH07XG5cbiAgLyoqXG4gICAqIEJpbmQgYSBkZWxlZ2F0ZWQgY2xpY2sgZXZlbnQgb24gdGhlIGNvbnRhaW5lcnNcbiAgICogd2l0aCBwdWJsaXNoIGVsZW1lbnRzLlxuICAgKlxuICAgKiBDb250YWluZXIgY2xhc3M6IC5yZXZlYWwtcHVibGlzaC1kZWxlZ2F0ZVxuICAgKiBQdWJsaXNoZXIgY2xhc3M6IC5yZXZlYWwtcHVibGlzaC1wdWJsaXNoZXJcbiAgICpcbiAgICogUHVibGlzaGVyIGF0dHJpYnV0ZXM6XG4gICAqIHZhbHVlOiAgICAgICBUaGUgdmFsdWUgd2lsbCBiZSB1c2VkIHRvIGRldGVybWFpbiBpZiBhIHN1YnNjcmliZXIgc2hvdWxkIHNob3cvaGlkZS5cbiAgICogICAgICAgICAgICAgIFRoZSB2YWx1ZXMgY2FuIGJlIGFueSB2YWxpZCBzdHJpbmcuXG4gICAqIGRhdGEtdGFyZ2V0OiBUaGUgZXZlbnQgbmFtZSB0byBzdWJzY3JpYmUgdG8uXG4gICAqXG4gICAqIEV4YW1wbGU6XG4gICAqIDxkaXYgY2xhc3M9XCJyZXZlYWwtcHVibGlzaC1kZWxlZ2F0ZVwiPlxuICAgICAgICA8aW5wdXQgIG5hbWU9XCJzYW1wbGVcIiB0eXBlPVwicmFkaW9cIlxuICAgICAgICAgICAgICAgIGNsYXNzPVwicmV2ZWFsLXB1Ymxpc2gtcHVibGlzaGVyXCJcbiAgICAgICAgICAgICAgICB2YWx1ZT1cInRydWVcIlxuICAgICAgICAgICAgICAgIGRhdGEtdGFyZ2V0PVwiZXZlbnROYW1lXCIgLz5cblxuICAgICAgICA8aW5wdXQgIG5hbWU9XCJzYW1wbGVcIiB0eXBlPVwicmFkaW9cIlxuICAgICAgICAgICAgICAgIGNsYXNzPVwicmV2ZWFsLXB1Ymxpc2gtcHVibGlzaGVyXCJcbiAgICAgICAgICAgICAgICB2YWx1ZT1cImZhbHNlXCJcbiAgICAgICAgICAgICAgICBkYXRhLXRhcmdldD1cImV2ZW50TmFtZVwiIC8+XG4gICAgICA8L2Rpdj5cbiAgICovXG4gIHJldmVhbFB1YlN1Yi5iaW5kUHVibGlzaCA9IGZ1bmN0aW9uICgpIHtcbiAgICAkKCcucmV2ZWFsLXB1Ymxpc2gtZGVsZWdhdGUnKS5vbignY2xpY2sgcHNldWRvLWNsaWNrJywgJy5yZXZlYWwtcHVibGlzaC1wdWJsaXNoZXInLCBmdW5jdGlvbiAoZSkge1xuICAgICAgZS5zdG9wUHJvcGFnYXRpb24oKTsgLy8gc3RvcCBuZXN0ZWQgZWxlbWVudHMgdG8gZmlyZSBldmVudCB0d2ljZVxuICAgICAgdmFyICRlbCA9ICQoZS50YXJnZXQpLFxuICAgICAgICBlbFZhbHVlID0gJGVsWzBdLnR5cGUgPT09ICdjaGVja2JveCcgPyAkZWxbMF0uY2hlY2tlZC50b1N0cmluZygpIDogJGVsLnZhbCgpO1xuXG4gICAgICAkLnB1Ymxpc2goJGVsLmF0dHIoJ2RhdGEtdGFyZ2V0JyksIGVsVmFsdWUpO1xuICAgIH0pO1xuICB9O1xuXG4gIC8qKlxuICAgKiBCaW5kIGVsZW1lbnRzIHRoYXQgc3Vic2NyaWJlIHRvIGV2ZW50cy5cbiAgICpcbiAgICogU3Vic2NyaWJlciBjbGFzczogLnJldmVhbC1zdWJzY3JpYmVcbiAgICpcbiAgICogU3Vic2NyaWJlciBhdHRyaWJ1dGVzOlxuICAgKiBkYXRhLXRhcmdldDogICAgICAgVGhlIGV2ZW50IG5hbWUgdG8gc3Vic2NpYmUgdG8uXG4gICAqIGRhdGEtc2hvdy1hcnJheTogICBBbiBhcnJheSBvZiB2YWx1ZXMgdGhhdCB3aWxsIHNob3cgdGhlIGVsZW1lbnQsXG4gICAqICAgICAgICAgICAgICAgICAgICB0aGlzIGNvcnJlc3BvbmRzIHRvIHRoZSBwdXBsaXNoZXIgdmFsdWUgYXR0cmlidXRlXG4gICAqXG4gICAqIEV4YW1wbGU6XG4gICAqICA8ZGl2ICBjbGFzcz1cInJldmVhbC1zdWJzY3JpYmVcIlxuICAgICAgICAgICAgZGF0YS10YXJnZXQ9XCJldmVudE5hbWVcIlxuICAgICAgICAgICAgZGF0YS1zaG93LWFycmF5PVwidHJ1ZXwuLl1cIj5cbiAgICAgICAgICAgICAgLy8gRnVydGhlciBIVE1MIGhlcmVcbiAgICAgIDwvZGl2PlxuICAgKlxuICAgKiBPcHRpb25hbDpcbiAgICogICBTZWUgZGVmYXVsdHMuYXJpYSAmIGRlZmF1bHRzLmFyaWFIaWRkZW5PbkluaXRcbiAgICogICAgIC0gYXBwbHkgYXJpYS1oaWRkZW4gb24gaW5pdC5cbiAgICogICAgIC0gYXBsbHkgYXJpYS1oaWRkZW4gd2hlbiB0aGUgc3RhdGUgY2hhbmdlcyBvbiBhbiBlbGVtZW50LlxuICAgKi9cbiAgcmV2ZWFsUHViU3ViLmJpbmRTdWJzY3JpYmUgPSBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIF90aGlzID0gdGhpcztcblxuICAgICQoJy5yZXZlYWwtc3Vic2NyaWJlJykuaXMoZnVuY3Rpb24gKGlkeCwgZWwpIHtcbiAgICAgIHZhciAkZWwgPSAkKGVsKTtcblxuICAgICAgLy8gQXBwbHlpbmcgQXJpYSBIaWRkZW4gYXR0cmlidXRlc1xuICAgICAgaWYgKF90aGlzLnNldHRpbmdzLmFyaWEgJiYgX3RoaXMuc2V0dGluZ3MuYXJpYUhpZGRlbk9uSW5pdCkge1xuICAgICAgICBfdGhpcy5zZXRBcmlhSGlkZGVuT25Jbml0KCRlbCk7XG4gICAgICB9XG5cbiAgICAgIC8vIFN1YnNjcmliZSB0byB0aGUgZXZlbnRzXG4gICAgICAkLnN1YnNjcmliZSgkZWwuYXR0cignZGF0YS10YXJnZXQnKSwgZnVuY3Rpb24gKGV2ZW50LCB2YWwpIHtcbiAgICAgICAgdmFyIGFyaWFIaWRkZW47XG4gICAgICAgIHZhciBpc0luQXJyYXkgPSAkLmluQXJyYXkodmFsLCAkZWwuYXR0cignZGF0YS1zaG93LWFycmF5Jykuc3BsaXQoX3RoaXMuc2V0dGluZ3MuZGF0YVNob3dBcnJheURlbGltaXRlcikpO1xuXG4gICAgICAgIGlmIChpc0luQXJyYXkgIT09IC0xKSB7XG4gICAgICAgICAgJGVsLnNob3coKTtcbiAgICAgICAgICBhcmlhSGlkZGVuID0gZmFsc2U7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgJGVsLmhpZGUoKTtcbiAgICAgICAgICBhcmlhSGlkZGVuID0gdHJ1ZTtcbiAgICAgICAgfVxuXG4gICAgICAgIGlmIChfdGhpcy5zZXR0aW5ncy5hcmlhKSB7XG4gICAgICAgICAgcmV2ZWFsUHViU3ViLnNldEFyaWFIaWRkZW4oJGVsLCBhcmlhSGlkZGVuKTtcbiAgICAgICAgfVxuICAgICAgfSk7XG5cblxuICAgIH0pO1xuICB9O1xuXG4gIC8qKlxuICAgKiBUcmlnZ2VyIGFsbCB0aGUgY2xpY2sgZXZlbnRzIG9uIHB1Ymxpc2hlcnMgdGhhdFxuICAgKiBhcmUgOmNoZWNrZWQuIFRoaXMgaXMgYSBmZWF0dXJlLiBTZWU6IHRoaXMuc2V0dGluZ3MudHJpZ2dlclB1YnNBZnRlckJpbmQuXG4gICAqIHRydWUgYnkgZGVmYXVsdC5cbiAgICovXG4gIHJldmVhbFB1YlN1Yi50cmlnZ2VyUHVibGlzaGVycyA9IGZ1bmN0aW9uICgpIHtcbiAgICAkKCcucmV2ZWFsLXB1Ymxpc2gtcHVibGlzaGVyJykuaXMoZnVuY3Rpb24gKGlkeCwgZWwpIHtcbiAgICAgIHZhciAkZWwgPSAkKHRoaXMpO1xuICAgICAgaWYgKCRlbC5pcygnOmNoZWNrZWQnKSkge1xuICAgICAgICAkZWwudHJpZ2dlcigncHNldWRvLWNsaWNrJyk7XG4gICAgICB9XG4gICAgfSk7XG4gIH07XG5cbiAgLyoqXG4gICAqIEFwcGx5IGFyaWEtaGlkZGVuIGF0dHJpYnV0ZXMgdG8gc3Vic2NpYmVyc1xuICAgKiB0byByZWZsZWN0IHRoZWlyIHN0YXRlIG9uIGluaXQoKVxuICAgKiBAcGFyYW0ge1t0eXBlXX0gJGVsIGpRdWVyeSBlbGVtZW50XG4gICAqL1xuICByZXZlYWxQdWJTdWIuc2V0QXJpYUhpZGRlbk9uSW5pdCA9IGZ1bmN0aW9uICgkZWwpIHtcbiAgICBpZiAoISRlbC5pcygnOnZpc2libGUnKSkge1xuICAgICAgcmV2ZWFsUHViU3ViLnNldEFyaWFIaWRkZW4oJGVsLCB0cnVlKTtcbiAgICAgIHJldHVybjtcbiAgICB9XG4gICAgcmV2ZWFsUHViU3ViLnNldEFyaWFIaWRkZW4oJGVsLCBmYWxzZSk7XG4gIH07XG5cbiAgLyoqXG4gICAqIFV0aWwgbWV0aG9kIHRoYXQgY2hhbmdlcyB0aGUgYXJpYS1oaWRkZW5cbiAgICogYXR0cmlidXRlIGFzIHJlcXVpcmVkXG4gICAqIEBwYXJhbSB7W3R5cGVdfSAkZWwgIGpRdWVyeSBlbGVtZW50XG4gICAqIEBwYXJhbSB7W3R5cGVdfSBib29sIHRoZSBhcmlhLWhpZGRlbiBhdHRyaWJ1dGUgd2lsbCBiZSBzZXQgdG8gdGhpcyB2YWx1ZVxuICAgKi9cbiAgcmV2ZWFsUHViU3ViLnNldEFyaWFIaWRkZW4gPSBmdW5jdGlvbiAoJGVsLCBib29sKSB7XG4gICAgcmV0dXJuIGJvb2wgPyAkZWwuYXR0cignYXJpYS1oaWRkZW4nLCB0cnVlKSA6ICRlbC5hdHRyKCdhcmlhLWhpZGRlbicsIGZhbHNlKTtcbiAgfTtcblxuICAvKipcbiAgICogUmV0dXJuIHRoZSBtb2R1bGVcbiAgICogTk9URTogQ2FsbCB0aGUgaW5pdCBtZXRob2Qgb3V0c2lkZSBwYXNzaW5nIGFueVxuICAgKiAgICAgICBzZXR0aW5ncyB0byBvdmVycmlkZSBkZWZhdWx0c1xuICAgKi9cbiAgcmV0dXJuIHJldmVhbFB1YlN1Yjtcbn0oKSk7XG4iLCIvKiBUb2dnbGVzIHNlbGVjdGVkIG9wdGlvbiBjbGFzcywgYXNzdW1lcyB0aGUgZm9sbG93aW5nIHN0cnVjdHVyZVxuKiAub3B0aW9ucyA+IC5ibG9jay1sYWJlbCArIC5ibG9jay1sYWJlbCA+IGxhYmVsID4gaW5wdXRbOnJhZGlvIHx8IDpjaGVja2JveF1cbiovXG5cbm1vZHVsZS5leHBvcnRzID0gKGZ1bmN0aW9uKCkge1xuICAndXNlIHN0cmljdCc7XG5cbiAgdmFyIHNlbGVjdGVkT3B0aW9uID0ge30sXG4gICAgb3B0aW9ucyA9ICQoJy5vcHRpb25zLCAuY2hlY2tfYm94ZXMnKSxcbiAgICBjaGFuZ2VfY2xhc3MgPSAnc2VsZWN0ZWQnLFxuICAgIGZvY3VzYmx1cl9jbGFzcyA9ICdhZGQtZm9jdXMnO1xuXG4gIHNlbGVjdGVkT3B0aW9uLmluaXQgPSBmdW5jdGlvbigpIHtcbiAgICBvcHRpb25zLmVhY2goZnVuY3Rpb24oaSwgY29udGFpbmVyKXtcbiAgICAgIHZhciBpbnB1dF9ncm91cCA9ICQoY29udGFpbmVyKS5maW5kKCcuYmxvY2stbGFiZWwsIC5zbGltLWxhYmVsJyk7XG5cbiAgICAgIHNlbGVjdGVkT3B0aW9uLmJpbmRJbnB1dEV2ZW50cyhpbnB1dF9ncm91cCk7XG5cbiAgICB9KTtcbiAgfTtcblxuICBzZWxlY3RlZE9wdGlvbi5iaW5kSW5wdXRFdmVudHMgPSBmdW5jdGlvbihpbnB1dF9ncm91cCkge1xuICAgIGlucHV0X2dyb3VwLmVhY2goZnVuY3Rpb24oaSwgYmxvY2tsYWJlbCl7XG4gICAgICB2YXIgY29udGFpbmVyID0gJChibG9ja2xhYmVsKSxcbiAgICAgICAgc2libGluZ3MgPSBjb250YWluZXIuc2libGluZ3MoKS5maW5kKCdsYWJlbCcpLFxuICAgICAgICBpbnB1dCA9IGNvbnRhaW5lci5maW5kKCdpbnB1dCcpLFxuICAgICAgICBpc19yYWRpbyA9IGlucHV0LmlzKCc6cmFkaW8nKSxcbiAgICAgICAgbGFiZWwgPSBjb250YWluZXIuZmluZCgnbGFiZWwnKTtcblxuICAgICAgaW5wdXQub24oJ2NoYW5nZScsIGZ1bmN0aW9uKCl7XG4gICAgICAgIHZhciBpc19jaGVja2VkID0gaW5wdXQuaXMoJzpjaGVja2VkJyk7XG5cbiAgICAgICAgaWYoaXNfY2hlY2tlZCAmJiBpc19yYWRpbykge1xuICAgICAgICAgIHNpYmxpbmdzLnJlbW92ZUNsYXNzKGNoYW5nZV9jbGFzcyk7XG4gICAgICAgIH1cblxuICAgICAgICBsYWJlbC50b2dnbGVDbGFzcyhjaGFuZ2VfY2xhc3MsIGlzX2NoZWNrZWQpO1xuXG4gICAgICB9KVxuICAgICAgLm9uKCdmb2N1cycsIGZ1bmN0aW9uKCl7XG4gICAgICAgIGxhYmVsLmFkZENsYXNzKGZvY3VzYmx1cl9jbGFzcyk7XG4gICAgICB9KVxuICAgICAgLm9uKCdibHVyJywgZnVuY3Rpb24oKXtcbiAgICAgICAgbGFiZWwucmVtb3ZlQ2xhc3MoZm9jdXNibHVyX2NsYXNzKTtcbiAgICAgIH0pXG4gICAgICAuY2hhbmdlKCk7XG4gICAgfSk7XG4gIH07XG5cbiAgc2VsZWN0ZWRPcHRpb24uaW5pdCgpO1xuXG4gIHJldHVybiBzZWxlY3RlZE9wdGlvbjtcblxufSkoKTtcbiIsIi8vIE1hbmFnZXMgc2Vzc2lvbiB0aW1lb3V0ICYgZGlzcGxheXMgcHJvbXB0IHByaW9yIHRvIHNlc3Npb24gZXhwaXJ5XG5tb2R1bGUuZXhwb3J0cyA9IChmdW5jdGlvbiAoKSB7XG5cbiAgdmFyIHNldHRpbmdzID0ge1xuICAgIFNFQ09ORDogMTAwMFxuICB9O1xuICBzZXR0aW5ncy5NSU5VVEUgPSA2MCAqIHNldHRpbmdzLlNFQ09ORDtcbiAgc2V0dGluZ3MuRklWRV9NSU5VVEVTID0gNSAqIHNldHRpbmdzLk1JTlVURTtcbiAgc2V0dGluZ3MuRklGVFlfRklWRV9NSU5VVEVTID0gNTUgKiBzZXR0aW5ncy5NSU5VVEU7XG5cbiAgdmFyIHNlc3Npb25Qcm9tcHQgPSB7XG5cbiAgICB0aW1lclJlZjogbnVsbCxcblxuICAgIGluaXQ6IGZ1bmN0aW9uIChvcHRpb25zKSB7XG4gICAgICBzZXR0aW5ncyA9ICQuZXh0ZW5kKHNldHRpbmdzLCBvcHRpb25zKTtcbiAgICAgIHRoaXMuY291bnRlciA9IHNldHRpbmdzLkZJVkVfTUlOVVRFUztcbiAgICAgIHRoaXMudXBkYXRlVGltZUxlZnRPblByb21wdCh0aGlzLmNvdW50ZXIpO1xuICAgICAgdGhpcy5zZXRQcm9tcHRFeHRlbmRTZXNzaW9uQ2xpY2tFdmVudCgpO1xuICAgICAgdGhpcy5zdGFydFNlc3Npb25UaW1lcigpO1xuICAgIH0sXG5cbiAgICBzdGFydFNlc3Npb25UaW1lcjogZnVuY3Rpb24gKCkge1xuICAgICAgc2V0VGltZW91dCgkLnByb3h5KHRoaXMudGltZW91dFByb21wdCwgdGhpcyksIHNldHRpbmdzLkZJRlRZX0ZJVkVfTUlOVVRFUyk7XG4gICAgfSxcblxuICAgIHNldFByb21wdEV4dGVuZFNlc3Npb25DbGlja0V2ZW50OiBmdW5jdGlvbiAoKSB7XG4gICAgICAkKFwiI3Nlc3Npb25fcHJvbXB0X2NvbnRpbnVlX2J0blwiKS51bmJpbmQoKS5vbihcImNsaWNrXCIsICQucHJveHkodGhpcy5yZWZyZXNoU2Vzc2lvbiwgdGhpcykpO1xuICAgIH0sXG5cbiAgICB0aW1lb3V0UHJvbXB0OiBmdW5jdGlvbiAoKSB7XG4gICAgICB0aGlzLnRpbWVyUmVmID0gc2V0SW50ZXJ2YWwoJC5wcm94eSh0aGlzLnByb21wdFVwZGF0ZSwgdGhpcyksIHNldHRpbmdzLlNFQ09ORCk7XG4gICAgICB0aGlzLnRvZ2dsZVByb21wdFZpc2liaWxpdHkoKTtcbiAgICB9LFxuXG4gICAgcHJvbXB0VXBkYXRlOiBmdW5jdGlvbiAoKSB7XG4gICAgICBpZiAodGhpcy5jb3VudGVyID09PSAwKSB7XG4gICAgICAgIHRoaXMuZXhwaXJlU2Vzc2lvbigpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdGhpcy5jb3VudGVyIC09IHNldHRpbmdzLlNFQ09ORDtcbiAgICAgICAgdGhpcy51cGRhdGVUaW1lTGVmdE9uUHJvbXB0KHRoaXMuY291bnRlcik7XG4gICAgICB9XG4gICAgfSxcblxuICAgIHRvZ2dsZVByb21wdFZpc2liaWxpdHk6IGZ1bmN0aW9uICgpIHtcbiAgICAgICQoXCIjc2Vzc2lvbl9wcm9tcHRcIikudG9nZ2xlQ2xhc3MoXCJoaWRkZW5cIik7XG4gICAgfSxcblxuICAgIHVwZGF0ZVRpbWVMZWZ0T25Qcm9tcHQ6IGZ1bmN0aW9uICh0aW1lSW5NaWxsaXMpIHtcbiAgICAgIHZhciBzZWNvbmRzID0gdGltZUluTWlsbGlzIC8gc2V0dGluZ3MuU0VDT05EO1xuICAgICAgdmFyIG1pbnMgPSBNYXRoLmZsb29yKHNlY29uZHMgLyA2MCk7XG4gICAgICB2YXIgc2VjcyA9IHNlY29uZHMgJSA2MDtcbiAgICAgIHZhciB0aW1lID0gKG1pbnMgPT09IDApID8gc2VjcyA6IChtaW5zICsgXCI6XCIgKyB0aGlzLnBhZFNlY29uZHMoc2VjcykpO1xuICAgICAgJCgnI3Nlc3Npb25fcHJvbXB0X3RpbWVfbGVmdCcpLnRleHQodGltZSk7XG4gICAgfSxcblxuICAgIHBhZFNlY29uZHM6IGZ1bmN0aW9uIChzZWNzKSB7XG4gICAgICByZXR1cm4gKChzZWNzICsgXCJcIikubGVuZ3RoID09PSAxKSA/IFwiMFwiICsgc2VjcyA6IHNlY3M7XG4gICAgfSxcblxuICAgIGV4cGlyZVNlc3Npb246IGZ1bmN0aW9uICgpIHtcbiAgICAgIGxvY2F0aW9uLmhyZWYgPSBsb2NhdGlvbi5wcm90b2NvbCArIFwiLy9cIiArIGxvY2F0aW9uLmhvc3QgKyBcIi9hcHBsaWNhdGlvbi9zZXNzaW9uLWV4cGlyZWRcIjtcbiAgICB9LFxuXG4gICAgcmVmcmVzaFNlc3Npb246IGZ1bmN0aW9uICgpIHtcbiAgICAgIGNsZWFySW50ZXJ2YWwodGhpcy50aW1lclJlZik7XG4gICAgICAkLmFqYXgoe1xuICAgICAgICB1cmw6IFwiL2FwcGxpY2F0aW9uL3JlZnJlc2gtc2Vzc2lvblwiXG4gICAgICB9KS5kb25lKFxuICAgICAgICAkLnByb3h5KGZ1bmN0aW9uICgpIHtcbiAgICAgICAgICB0aGlzLnRvZ2dsZVByb21wdFZpc2liaWxpdHkoKTtcbiAgICAgICAgICB0aGlzLmluaXQoKTtcbiAgICAgICAgfSwgdGhpcylcbiAgICAgICk7XG4gICAgfVxuICB9O1xuXG5cbiAgdmFyIGlzQ2xhaW1QYXRoID0gZnVuY3Rpb24gKCkge1xuICAgIHJldHVybiAhIWxvY2F0aW9uLnBhdGhuYW1lLm1hdGNoKC9eXFwvYXBwbHlcXC8uKi8pO1xuICB9O1xuXG4gIGlmIChpc0NsYWltUGF0aCgpKSB7XG4gICAgc2Vzc2lvblByb21wdC5pbml0KCk7XG4gIH1cblxuICByZXR1cm4gc2Vzc2lvblByb21wdDtcblxufSkoKTtcbiIsIi8vIHN0YXRlIGluZGljYXRvclxuLy8gVGhpcyByZXF1aXJlcyBDU1MgbWVkaWEgcXVlcmllcyB0aGF0XG4vLyB1cGRhdGUgdGhlIHotaW5kZXggb24gZGl2LnN0YXRlLWluZGljYXRvci5cbi8vIFRoZSBlbGVtZW50IHdpbGwgYmUgY3JlYXRlZCBieSB0aGUgSlMuXG5tb2R1bGUuZXhwb3J0cyA9IChmdW5jdGlvbiAoKSB7XG5cbiAgLy8gRGVib3VuY2VcbiAgLy8gaHR0cDovL2Rhdmlkd2Fsc2gubmFtZS9mdW5jdGlvbi1kZWJvdW5jZVxuICB2YXIgZGVib3VuY2UgPSBmdW5jdGlvbiAoZnVuYywgd2FpdCwgaW1tZWRpYXRlKSB7XG4gICAgdmFyIHRpbWVvdXQ7XG4gICAgcmV0dXJuIGZ1bmN0aW9uICgpIHtcbiAgICAgIHZhciBjb250ZXh0ID0gdGhpcyxcbiAgICAgICAgYXJncyA9IGFyZ3VtZW50cztcbiAgICAgIHZhciBsYXRlciA9IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgdGltZW91dCA9IG51bGw7XG4gICAgICAgIGlmICghaW1tZWRpYXRlKSBmdW5jLmFwcGx5KGNvbnRleHQsIGFyZ3MpO1xuICAgICAgfTtcbiAgICAgIHZhciBjYWxsTm93ID0gaW1tZWRpYXRlICYmICF0aW1lb3V0O1xuICAgICAgY2xlYXJUaW1lb3V0KHRpbWVvdXQpO1xuICAgICAgdGltZW91dCA9IHNldFRpbWVvdXQobGF0ZXIsIHdhaXQpO1xuICAgICAgaWYgKGNhbGxOb3cpIGZ1bmMuYXBwbHkoY29udGV4dCwgYXJncyk7XG4gICAgfTtcbiAgfTtcblxuICAvLyBzZXR0aW5nIHNvbWUgZGVmYXVsdHNcbiAgdmFyIHN0YXRlSW5kaWNhdG9yID0ge1xuICAgIHN0YXRlczoge1xuICAgICAgODAwMTogJ21vYmlsZScsXG4gICAgICA4MDAyOiAndGFibGV0JyxcbiAgICAgIDgwMDM6ICdkZXNrdG9wJ1xuICAgIH0sXG4gICAgYmFzZVN0YXRlOiAnZGVza3RvcCdcbiAgfTtcblxuICAvLyBKdXN0IGEgbGl0dGxlIHNob3J0ZXIgdG8gd3JpdGVcbiAgdmFyIHNpID0gc3RhdGVJbmRpY2F0b3I7XG5cbiAgc2kuaW5pdCA9IGZ1bmN0aW9uICgpIHtcbiAgICAvLyBjcmVhdGUgdGhlIGVsZW1lbnRcbiAgICBzaS5fX2NyZWF0ZUVsZW1lbnQoKTtcblxuICAgIC8vIHJ1biB0aGUgaGFuZGxlciBtYW51YWxseSBhdCBzdGFydFxuICAgIHNpLl9faGFuZGxlT3JpZW50YXRpb24oKTtcblxuICAgIHNpLmJpbmRUb1Jlc2l6ZSgpO1xuICB9O1xuXG4gIC8vIEJpbmQgdG8gdGhlIHJlc2l6ZSAvIG9ub3JpZW50YXRpb25jaGFuZ2UgZXZlbnRcbiAgc2kuYmluZFRvUmVzaXplID0gZnVuY3Rpb24gKCkge1xuICAgIHNpLl9fbGFzdERldmljZVN0YXRlID0gc2kuZ2V0RGV2aWNlU3RhdGUoKTtcbiAgICB2YXIgX3N1cHBvcnRzX29yaWVudGF0aW9uID0gXCJvbm9yaWVudGF0aW9uY2hhbmdlXCIgaW4gd2luZG93O1xuICAgIHZhciBfb3JpZW50YXRpb25fZXZlbnQgPSBfc3VwcG9ydHNfb3JpZW50YXRpb24gPyBcIm9yaWVudGF0aW9uY2hhbmdlXCIgOiBcInJlc2l6ZVwiO1xuXG4gICAgaWYgKHdpbmRvdy5hZGRFdmVudExpc3RlbmVyKSB7XG4gICAgICB3aW5kb3cuYWRkRXZlbnRMaXN0ZW5lcihfb3JpZW50YXRpb25fZXZlbnQsIHNpLl9faGFuZGxlT3JpZW50YXRpb24sIGZhbHNlKTtcbiAgICB9IGVsc2UgaWYgKHdpbmRvdy5hdHRhY2hFdmVudCkge1xuICAgICAgd2luZG93LmF0dGFjaEV2ZW50KF9vcmllbnRhdGlvbl9ldmVudCwgc2kuX19oYW5kbGVPcmllbnRhdGlvbik7XG4gICAgfSBlbHNlIHtcbiAgICAgIHdpbmRvd1tfb3JpZW50YXRpb25fZXZlbnRdID0gc2kuX19oYW5kbGVPcmllbnRhdGlvbjtcbiAgICB9XG4gIH07XG5cbiAgLy8gUmV0dXJuIHRoZSBjdXJyZW50IHN0YXRlIGJhc2VkIG9uIHRoZVxuICAvLyB6LWluZGV4IGZvciB0aGUgaGlkZGVuIGVsZW1lbnRcbiAgLy8gZGVmYXVsdHMgdG8gc2kuYmFzZVN0YXRlXG4gIHNpLmdldERldmljZVN0YXRlID0gZnVuY3Rpb24gKCkge1xuICAgIHZhciBpbmRleCA9IHBhcnNlSW50KHNpLiRpbmRpY2F0b3IuY3NzKCd6LWluZGV4JyksIDEwKTtcbiAgICByZXR1cm4gc2kuc3RhdGVzW2luZGV4XSB8fCBzaS5iYXNlU3RhdGU7XG4gIH07XG5cbiAgc2kuX19oYW5kbGVPcmllbnRhdGlvbiA9IGRlYm91bmNlKGZ1bmN0aW9uICgpIHtcbiAgICBzaS5fX3N0YXRlID0gc2kuZ2V0RGV2aWNlU3RhdGUoKTtcblxuICAgIGlmIChzaS5fX3N0YXRlICE9PSBzaS5fX2xhc3REZXZpY2VTdGF0ZSkge1xuICAgICAgLy8gU2F2ZSB0aGUgbmV3IHN0YXRlIGFzIGN1cnJlbnRcblxuICAgICAgLy8gUHVibGlzaGVzIHR3byBldmVudHM6XG4gICAgICAvLyAtIEEgc3RhdGUgY2hhbmdlIG9jY3VyZWQgKC9kZXZpY2UvY2hhbmdlLylcbiAgICAgIC8vIC0gVGhlIHRvIC8gZnJvbSBkaXJlY3Rpb24gKC9kZXZpY2UvbW92ZS9bZnJvbVN0YXRlXS90by9bdG9TdGF0ZV0pXG4gICAgICAvLyAtIFRoZSBhY3R1YWwgc3RhdGUgd2lsbCBiZSBwYXNzZWQgaW50byB0aGUgY2FsbGJhY2tcbiAgICAgIGlmICgkLnB1Ymxpc2gpIHtcbiAgICAgICAgJC5wdWJsaXNoKCcvZGV2aWNlL2NoYW5nZS8nLCBbc2kuX19zdGF0ZV0pO1xuICAgICAgICAkLnB1Ymxpc2goJy9kZXZpY2UvbW92ZS8nICsgc2kuX19sYXN0RGV2aWNlU3RhdGUgKyAnL3RvLycgKyBzaS5fX3N0YXRlICsgJy8nLCBbc2kuX19zdGF0ZV0pO1xuICAgICAgfVxuICAgICAgc2kuX19sYXN0RGV2aWNlU3RhdGUgPSBzaS5fX3N0YXRlO1xuICAgIH1cbiAgfSwgMjApO1xuXG4gIHNpLl9fY3JlYXRlRWxlbWVudCA9IGZ1bmN0aW9uICgpIHtcbiAgICAvLyBDcmVhdGUgdGhlIHN0YXRlLWluZGljYXRvciBlbGVtZW50XG4gICAgc2kuaW5kaWNhdG9yID0gZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgnZGl2Jyk7XG4gICAgc2kuaW5kaWNhdG9yLmNsYXNzTmFtZSA9ICdzdGF0ZS1pbmRpY2F0b3InO1xuICAgIGRvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoc2kuaW5kaWNhdG9yKTtcbiAgICBzaS4kaW5kaWNhdG9yID0gJChzaS5pbmRpY2F0b3IpO1xuICB9O1xuXG4gIC8vLy8vLy8vLy8vLy8vLy9cbiAgLy8gSW5pdCBzdGVwcyAvL1xuICAvLy8vLy8vLy8vLy8vLy8vXG4gIHNpLmluaXQoKTtcblxuICByZXR1cm4gc3RhdGVJbmRpY2F0b3I7XG59KSgpO1xuIiwibW9kdWxlLmV4cG9ydHMgPSAoZnVuY3Rpb24gKCkge1xuIC8qISBodHRwOi8vbXRocy5iZS9kZXRhaWxzIHYwLjEuMCBieSBAbWF0aGlhcyB8IGluY2x1ZGVzIGh0dHA6Ly9tdGhzLmJlL25vc2VsZWN0IHYxLjAuMyAqL1xuOyhmdW5jdGlvbihhLGYpe3ZhciBlPWYuZm4sZCxjPU9iamVjdC5wcm90b3R5cGUudG9TdHJpbmcuY2FsbCh3aW5kb3cub3BlcmEpPT0nW29iamVjdCBPcGVyYV0nLGc9KGZ1bmN0aW9uKGwpe3ZhciBqPWwuY3JlYXRlRWxlbWVudCgnZGV0YWlscycpLGksaCxrO2lmKCEoJ29wZW4nIGluIGopKXtyZXR1cm4gZmFsc2V9aD1sLmJvZHl8fChmdW5jdGlvbigpe3ZhciBtPWwuZG9jdW1lbnRFbGVtZW50O2k9dHJ1ZTtyZXR1cm4gbS5pbnNlcnRCZWZvcmUobC5jcmVhdGVFbGVtZW50KCdib2R5JyksbS5maXJzdEVsZW1lbnRDaGlsZHx8bS5maXJzdENoaWxkKX0oKSk7ai5pbm5lckhUTUw9JzxzdW1tYXJ5PmE8L3N1bW1hcnk+Yic7ai5zdHlsZS5kaXNwbGF5PSdibG9jayc7aC5hcHBlbmRDaGlsZChqKTtrPWoub2Zmc2V0SGVpZ2h0O2oub3Blbj10cnVlO2s9ayE9ai5vZmZzZXRIZWlnaHQ7aC5yZW1vdmVDaGlsZChqKTtpZihpKXtoLnBhcmVudE5vZGUucmVtb3ZlQ2hpbGQoaCl9cmV0dXJuIGt9KGEpKSxiPWZ1bmN0aW9uKGksbCxrLGgpe3ZhciBqPWkucHJvcCgnb3BlbicpLG09aiYmaHx8IWomJiFoO2lmKG0pe2kucmVtb3ZlQ2xhc3MoJ29wZW4nKS5wcm9wKCdvcGVuJyxmYWxzZSkudHJpZ2dlckhhbmRsZXIoJ2Nsb3NlLmRldGFpbHMnKTtsLmF0dHIoJ2FyaWEtZXhwYW5kZWQnLGZhbHNlKTtrLmhpZGUoKX1lbHNle2kuYWRkQ2xhc3MoJ29wZW4nKS5wcm9wKCdvcGVuJyx0cnVlKS50cmlnZ2VySGFuZGxlcignb3Blbi5kZXRhaWxzJyk7bC5hdHRyKCdhcmlhLWV4cGFuZGVkJyx0cnVlKTtrLnNob3coKX19O2Uubm9TZWxlY3Q9ZnVuY3Rpb24oKXt2YXIgaD0nbm9uZSc7cmV0dXJuIHRoaXMuYmluZCgnc2VsZWN0c3RhcnQgZHJhZ3N0YXJ0IG1vdXNlZG93bicsZnVuY3Rpb24oKXtyZXR1cm4gZmFsc2V9KS5jc3Moe01velVzZXJTZWxlY3Q6aCxtc1VzZXJTZWxlY3Q6aCx3ZWJraXRVc2VyU2VsZWN0OmgsdXNlclNlbGVjdDpofSl9O2lmKGcpe2Q9ZS5kZXRhaWxzPWZ1bmN0aW9uKCl7cmV0dXJuIHRoaXMuZWFjaChmdW5jdGlvbigpe3ZhciBpPWYodGhpcyksaD1mKCdzdW1tYXJ5JyxpKS5maXJzdCgpO2guYXR0cih7cm9sZTonYnV0dG9uJywnYXJpYS1leHBhbmRlZCc6aS5wcm9wKCdvcGVuJyl9KS5vbignY2xpY2snLGZ1bmN0aW9uKCl7dmFyIGo9aS5wcm9wKCdvcGVuJyk7aC5hdHRyKCdhcmlhLWV4cGFuZGVkJywhaik7aS50cmlnZ2VySGFuZGxlcigoaj8nY2xvc2UnOidvcGVuJykrJy5kZXRhaWxzJyl9KX0pfTtkLnN1cHBvcnQ9Z31lbHNle2Q9ZS5kZXRhaWxzPWZ1bmN0aW9uKCl7cmV0dXJuIHRoaXMuZWFjaChmdW5jdGlvbigpe3ZhciBoPWYodGhpcyksaj1mKCdzdW1tYXJ5JyxoKS5maXJzdCgpLGk9aC5jaGlsZHJlbignOm5vdChzdW1tYXJ5KScpLGs9aC5jb250ZW50cygnOm5vdChzdW1tYXJ5KScpO2lmKCFqLmxlbmd0aCl7aj1mKCc8c3VtbWFyeT4nKS50ZXh0KCdEZXRhaWxzJykucHJlcGVuZFRvKGgpfWlmKGkubGVuZ3RoIT1rLmxlbmd0aCl7ay5maWx0ZXIoZnVuY3Rpb24oKXtyZXR1cm4gdGhpcy5ub2RlVHlwZT09MyYmL1teIFxcdFxcblxcZlxccl0vLnRlc3QodGhpcy5kYXRhKX0pLndyYXAoJzxzcGFuPicpO2k9aC5jaGlsZHJlbignOm5vdChzdW1tYXJ5KScpfWgucHJvcCgnb3BlbicsdHlwZW9mIGguYXR0cignb3BlbicpPT0nc3RyaW5nJyk7YihoLGosaSk7ai5hdHRyKCdyb2xlJywnYnV0dG9uJykubm9TZWxlY3QoKS5wcm9wKCd0YWJJbmRleCcsMCkub24oJ2NsaWNrJyxmdW5jdGlvbigpe2ouZm9jdXMoKTtiKGgsaixpLHRydWUpfSkua2V5dXAoZnVuY3Rpb24obCl7aWYoMzI9PWwua2V5Q29kZXx8KDEzPT1sLmtleUNvZGUmJiFjKSl7bC5wcmV2ZW50RGVmYXVsdCgpO2ouY2xpY2soKX19KX0pfTtkLnN1cHBvcnQ9Z319KGRvY3VtZW50LGpRdWVyeSkpO1xufSkoKTtcblxuJChmdW5jdGlvbiAoKSB7XG4gICQoJ2RldGFpbHMnKS5kZXRhaWxzKCk7XG59KTsiXX0=
