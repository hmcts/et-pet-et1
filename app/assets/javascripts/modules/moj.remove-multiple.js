module.exports = (function() {
  'use strict';

  var removeMultiple = {
    init : function init() {
      var container = $('.additional-claimants'),
        claimant = container.find('.claimant');

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
