module.exports = (function() {
  'use strict';

  var removeMultiple = removeMultiple || {},
    container = $('.multiples'),
    multiples = container.find('.multiple');

  removeMultiple.init = function() {
    multiples.each(function(i, el) {
      var checkbox = $(el).find('.destroy-checkbox');
      //bind the remove method
      removeMultiple.setRemoveButton(el, checkbox);
      // hide if already checked
      el.style.display = checkbox.is(':checked') ? 'none' : 'block';
    });
    //update the counter
    removeMultiple.updateCount();
  };

  removeMultiple.setRemoveButton = function(el, checkbox) {
    var link = $(el).find('.remove-multiple');

    //hide on click and check the hidden checkbox
    link.on('click', function(event){
      el.style.display = 'none';

      checkbox.prop('checked', true);
      removeMultiple.updateCount();
    });
  };

  removeMultiple.updateCount = function() {
    var visibles = multiples.filter(':visible');

    // only update the counter on visible multiples
    visibles.each(function(i, el) {
      //incremented by 2 because the first is the main claimant
      var section = $(el),
        count = i + 2;
      // update the string for the user
      replaceCount(section.find('legend:first'), count);
    });

    function replaceCount(el, count) {
      return $(el).text(function()
        // find the last occurrence of a number in the string and replace it
        return $(el).text().replace(/\d+\Z/, count);
      });
    }
  };

  removeMultiple.init();

  return removeMultiple;

})();
