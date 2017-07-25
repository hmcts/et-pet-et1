var Countable = require('../vendor/Countable');

(function() {

  var countable = {};

  countable.init = function(area) {

    var max = $(area).attr('maxlength'),
      hint = $(area).prev('.form-hint'),
      txt = hint.text();

    // IE!
    if (!('maxLength' in area)) {
      max = area.attributes.maxLength.value;
      area.onkeypress = function () {
          if (this.value.length >= max) return false;
      }
    }

    Countable.live(area, callback);

    function callback(counter) {
      hint.html(txt + ' (' + remainder(counter.all) + ' characters remaining)');
    }

    function remainder(count){
      var remaining = parseInt(max - count, 10);

      if(count === 0) {
        return max;
      } else if(remaining >= max) {
        return '0';
      } else {
        return remaining;
      }
    }
  };

  $('textarea[maxlength]').each(function(i, area){
      countable.init(area);
  });

  return countable;
})();
