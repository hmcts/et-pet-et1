module.exports = (function() {
  'use strict';

  var removeMultiple = removeMultiple || {},
    container = $('.multiples'),
    multiples = container.find('.multiple');

  removeMultiple.init = function() {
    if(multiples.length <= 1) {
      multiples.find('.remove-multiple').hide();
    } else {
      multiples.each(function(i, el) {
        var checkbox = $(el).find('.destroy-checkbox');
        //bind the remove method
        removeMultiple.bindRemoveButton(el, checkbox);
        // hide if already checked
        el.style.display = checkbox.is(':checked') ? 'none' : 'block';
      });
      //check for new entry and scroll to it. assume there are no errors (dont override if they exist)

      if(!$('#error-summary').length || $('#error-summary').is(':hidden')){
        removeMultiple.checkForNewEntry();
      }
    }
    //update the counter
    removeMultiple.updateCount();
  };

  removeMultiple.checkForNewEntry = function() {
    //assume new multiple is at the bottom and the first name (required) are empty
    var last_multiple = multiples.filter(':last'),
      name_fields = last_multiple.find('input.medium-input');
    if(!name_fields.val()) {
      // scroll there
      $('html,body').animate({scrollTop: last_multiple.offset().top},'slow');
    }
  };

  removeMultiple.bindRemoveButton = function(el, checkbox) {
    var link = $(el).find('.remove-multiple');

    //hide on click and check the hidden checkbox
    link.on('click', function(){
      el.style.display = 'none';

      checkbox.prop('checked', true);
      removeMultiple.updateCount();
    });
  };

  removeMultiple.updateCount = function() {
    var visibles = multiples.filter(':visible');

    // only update the counter on visible multiples
    visibles.each(function(i, el) {
      var section = $(el),
        count = i + 2;
      // update the string for the user
      replaceNumber(section.find('legend:first'), count);
    });

    function replaceNumber(el, count) {
      return $(el).text(function() {
        return $(el).text().replace(/\d+/g, count);
      });
    }
  };

  removeMultiple.init();

  return removeMultiple;

})();
