/* Toggles selected option class, assumes the following structure
* .options > .block-label + .block-label > label > input[:radio || :checkbox]
*/

module.exports = (function() {

  var selectedOption = {},
  options = $('.options'),
  change_class = 'selected',
  focusblur_class = 'add-focus';

  selectedOption.init = function() {
    options.each(function(i, container){
      var input_group = $(container).find('.block-label');

      selectedOption.bindInputEvents(input_group);

    });
  };

  selectedOption.bindInputEvents = function(input_group) {
    input_group.each(function(i, blocklabel){
      var container = $(blocklabel),
      siblings = container.siblings().find('label'),
      input = container.find('input'),
      is_radio = input.is(':radio'),
      label = container.find('label');

      input.on('change', function(){
        var checked = input.is(':checked');

        if(checked && is_radio) {
          siblings.removeClass(change_class);
        }

        label.toggleClass(change_class, checked);

      })
      .on('focus', function(){
        label.addClass(focusblur_class);
      })
      .on('blur', function(){
        label.removeClass(focusblur_class);
      })
      .change();
    });
  };

  selectedOption.init();

  return selectedOption;

})();
