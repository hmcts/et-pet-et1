module.exports = (function () {

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  var gaTracking = {
    error: {
      type: 'event',
      label: 'error'
    },
    gaID: null
  };

  gaTracking.init = function () {
    gaTracking.pageView();
    gaTracking.errorMessageCheck();
  };

  gaTracking.gaProxy = function (data) {
    if (ga) {
      ga('send', data.type, data.label);
    }
  };

  gaTracking.pageView = function () {
    if (gaTracking.gaID) {
      ga('create', gaTracking.gaID, 'auto');
      ga('send', 'pageview');
      ga('set', 'anonymizeIP', true);
    }
  };

  gaTracking.bindListener = (function () {
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
  })();

  gaTracking.errorMessageCheck = function () {
    $('#error-summary').is(function () {
      gaTracking.gaProxy(gaTracking.error);
    });
  };

  return {
    init: function (gaID) {
      gaTracking.gaID = gaID;
      gaTracking.init();
    }
  };
})();
