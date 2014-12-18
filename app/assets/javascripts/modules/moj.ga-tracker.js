module.exports = (function ($) {

  var gaTracker = {
    error: {
      type: 'event',
      label: 'error'
    }
  };

  gaTracker.init = function () {
    gaTracker.bindListners();
    gaTracker.errorHook();
  };

  gaTracker.bindListners = function () {
    $('[data-ga-tracking-type]').on('click', function (e) {
      var $el = $(e.currentTarget),
        data = {
          type: $el.data('ga-type'),
          label: $el.data('ga-label')
        };
      gaTracker.gaProxy(data);
    });
  };

  gaTracker.errorHook = function () {
    $('#error-summary').is(function () {
      gaTracker.gaProxy(gaTracker.error);
    });
  };

  gaTracker.gaProxy = function (data) {
    if (ga) {
      ga('send', data.type, data.label);
    }
  };

  gaTracker.init();

  return gaTracker;
})(jQuery);
