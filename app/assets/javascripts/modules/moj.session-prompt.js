// Manages session timeout & displays prompt prior to session expiry
module.exports = (function() {

  var SECOND = 1000,
      MINUTE = 60 * SECOND,
      FIVE_MINUTES = 5 * MINUTE,
      FIFTY_FIVE_MINUTES = 55 * MINUTE;

  return {

    timerRef: null,

    init: function(){
      this.counter = FIVE_MINUTES;
      this.setPromptExtendSessionClickEvent();
      this.startSessionTimer();
    },

    startSessionTimer: function(){
      setTimeout($.proxy(this.timeoutPrompt, this), FIFTY_FIVE_MINUTES);
    },

    setPromptExtendSessionClickEvent: function(){
      $("#session_prompt_continue_btn").unbind().on("click", $.proxy(this.refreshSession, this));
    },

    timeoutPrompt: function(){
      this.timerRef = setInterval($.proxy(this.promptUpdate, this), SECOND);
      this.togglePromptVisibility();
    },

    promptUpdate: function(){
      if(this.counter === 0){
        this.expireSession();
      } else {
        this.counter -= SECOND;
        this.updateTimeLeftOnPrompt(this.counter/SECOND);
      }
    },

    togglePromptVisibility: function(){
      $("#session_prompt").toggleClass("hidden");
    },

    updateTimeLeftOnPrompt: function(seconds){
      var mins = ~~(seconds / 60);
      var secs = seconds % 60;
      var time = (mins === 0) ? secs : (mins + ":" + this.padSeconds(secs));
      $('#session_prompt_time_left').text(time);
    },

    padSeconds: function(secs){
      return ((secs + "").length === 1) ? "0" + secs : secs;
    },

    expireSession: function(){
      location.href = location.protocol + "//" + location.host + "/application/session-expired";
    },

    refreshSession: function(){
      clearInterval(this.timerRef);
      $.ajax({
        url: "/application/refresh-session"
      }).done(
        $.proxy(function(){
          this.togglePromptVisibility();
          this.init();
        }, this)
      );
    }
  }

})();
