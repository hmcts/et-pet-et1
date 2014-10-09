module.exports = (function() {
  'use strict';

  var revealPubSub = {};

  revealPubSub.init = function(options) {
    console.log('revealPubSub.init');


    //this.bindSubscribe();
    this.bindPublish();
    this.bindSubscribe();
  };

  revealPubSub.bindPublish = function() {
    $('.fx-publish-delegate').on('click', '.fx-publish-publisher', function(e) {
      e.stopPropagation(); // stop nested elements to fire event twice
      var $el = $(e.target);
      $.publish($el.data('target'), $el.val());
    });
  };

  revealPubSub.bindSubscribe = function() {
    $('.fx-subscribe').is(function(idx, el) {
      var $el = $(el);
      $.subscribe($el.data('target'), function(event, val) {
        console.log('Subscribed to callback:', $el.data('target'), val);
        if ($.inArray(val, $el.data('show-array')) !== -1) {
          $el.show();
          return;
        }
        $el.hide();
      });
    });
  };

  revealPubSub.init();

  return revealPubSub;
}());