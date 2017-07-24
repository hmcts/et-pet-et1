/**
 * Module dependancies:
 *   - jQuery
 *   - Tiny Pub / Sub
 *     https://github.com/cowboy/jquery-tiny-pubsub
 */

var revealPubSub = (function () {
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
