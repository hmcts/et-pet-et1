var countable = (function() {
  'use strict';

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
      var remaining = characters_left_language();
      hint.html(txt + ' (' + remainder(counter.all) + remaining +')');
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

  function characters_left_language() {
    if($('div.form-fields[lang="cy"]').length){
      var remaining = ' o nodau yn weddill';
    } else {
      var remaining = ' characters remaining';
    }
    return remaining;
  }

  return countable;
})();
