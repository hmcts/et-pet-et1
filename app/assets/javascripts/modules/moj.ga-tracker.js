module.exports = (function($) {

  var gaTracker = {
    debug: false
  };

  gaTracker.init = function() {
    gaTracker.bindListners();
  };

  gaTracker.bindListners = function () {
    $('[data-ga-tracking]').on('click', function(e){
      if(gaTracker.debug){
        e.preventDefault();
      }
      var data = {
        eventType: $(e.currentTarget).data('ga-tracking-event'),
        url: $(e.currentTarget).data('ga-tracking-url')
      };
      gaTracker.gaProxy(data);
    });
  };

  gaTracker.gaProxy = function (data) {
    if(ga){
      ga('send', data.eventType, data.url);
    }
  };

  gaTracker.init();

  return gaTracker;
})(jQuery);
