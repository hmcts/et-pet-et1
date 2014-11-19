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
        this.updateTimeLeftOnPrompt(this.counter / settings.SECOND);
      }
    },

    togglePromptVisibility: function () {
      $("#session_prompt").toggleClass("hidden");
    },

    updateTimeLeftOnPrompt: function (seconds) {
      var mins = ~~(seconds / 60);
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
