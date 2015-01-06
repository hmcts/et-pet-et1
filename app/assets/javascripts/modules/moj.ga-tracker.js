module.exports = (function ($) {
  'use strict';
  var ga = window.ga || undefined;

  var gaTracker = {
    error: {
      type: 'event',
      label: 'error'
    }
  };

  gaTracker.init = function () {
    gaTracker.bindListners();
    gaTracker.errorMessageCheck();
  };

  gaTracker.bindListners = function () {
    var $el, data;
    $('[data-ga-type]').on('click', function (e) {
      $el = $(e.currentTarget);
      if (!$el.data('hasClicked')) {
        data = {
          type: $el.data('ga-type'),
          label: $el.data('ga-label')
        };

        $el.data('hasClicked', true);
        gaTracker.gaProxy(data);
      }
    });
  };

  gaTracker.errorMessageCheck = function () {
    $('#error-summary').is(function () {
      gaTracker.gaProxy(gaTracker.error);
    });
  };

  gaTracker.gaProxy = function (data) {
    if(ga){
      ga('send', data.type, data.label);
    }
  };

  gaTracker.init();

  return gaTracker;
})(jQuery);
