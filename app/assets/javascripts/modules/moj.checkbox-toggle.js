// Toggles disabled groups of adjacent checkboxes

module.exports = (function() {
  var checkboxToggle = {
    init: function() {
      $('.form-group-checkbox-toggle').each(function(i, el) {
        var label = $(el).find('label');
        checkboxToggle.bindCheckboxes(label);
      });
    },
    bindCheckboxes: function(label) {
      var input = label.find('input'),
        target = $(document.getElementById(input.attr('data-target'))),
        checked = function(){
          return input.is(':not(:checked)');
        },
        checkboxes = target.find('label');

      input.on('click', function(){
        checkboxes.toggleClass('disabled', checked())
          .find('input').attr('disabled', checked());
      });
    }
  };

  checkboxToggle.init();

  return checkboxToggle;

})();