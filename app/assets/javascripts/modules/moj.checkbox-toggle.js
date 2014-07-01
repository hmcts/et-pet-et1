// Reveals hidden content

module.exports = (function() {
  var checkboxToggle = {
    init: function() {
      $('.form-group-checkbox-toggle').each(function(i, el) {
        var label = $(el).find('label');
        checkboxToggle.bindCheckboxes(label);
      });
    },
    bindCheckboxes: function(checkbox) {
      var target = $(document.getElementById(checkbox.attr('data-target'))),
        checked = function(){
          return checkbox.find('input').is(':not(:checked)');
        },
        slaves = target.find('label');

      checkbox.on('click', function(){
        slaves.toggleClass('disabled', checked())
          .find('input').attr('disabled', checked());
      });
    }
  };

  checkboxToggle.init();

  return checkboxToggle;

})();