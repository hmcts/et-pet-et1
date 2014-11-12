module.exports = (function() {
  'use strict';

  var removeMultiple = {
    init : function init() {
      var container = $('.multiples'),
        claimant = container.find('.multiple');

      claimant.each(function(i, el) {
        removeMultiple.bindRemoveButton($(el));
      });
    },
    bindRemoveButton : function bindRemoveButton(claimant) {
      var link = claimant.find('.remove-claimant');

      link.on('click', function(event){
        claimant.hide();
      });
    }
  };

  removeMultiple.init();

  return removeMultiple;

})();
