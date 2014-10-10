/**
 * Module dependancies:
 *   - jQuery
 *   - Tiny Pub / Sub
 *     https://github.com/cowboy/jquery-tiny-pubsub
 */

module.exports = (function() {
  'use strict';

  var revealPubSub = {};

  /**
   * Init the module
   */
  revealPubSub.init = function() {
    this.bindPublish();
    this.bindSubscribe();
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
  revealPubSub.bindPublish = function() {
    $('.reveal-publish-delegate').on('click', '.reveal-publish-publisher', function(e) {
      e.stopPropagation(); // stop nested elements to fire event twice
      var $el = $(e.target);
      $.publish($el.data('target'), $el.val());
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
   */
  revealPubSub.bindSubscribe = function() {
    $('.reveal-subscribe').is(function(idx, el) {
      var $el = $(el);
      $.subscribe($el.data('target'), function(event, val) {
        if ($.inArray(val, $el.data('show-array')) !== -1) {
          $el.show();
          return;
        }
        $el.hide();
      });
    });
  };

  /**
   * Call the init method
   * No config can be passed in but the module can
   * be changed to handle this.
   */
  revealPubSub.init();

  /**
   * Return the module
   */
  return revealPubSub;
}());