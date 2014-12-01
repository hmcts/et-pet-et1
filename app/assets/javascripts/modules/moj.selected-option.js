/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {

  function toggleParentClass(input, labels, label, checked, klass) {
    if(input.is(':radio')){
      labels.removeClass(klass);
    }
    label.toggleClass(klass, checked);
  }

  $('.options').each(function(i, container){
    var blocklabels = $(container).find('.block-label'),
      labels = blocklabels.find('label');

    labels.each(function(i, el){
      var label = $(el),
        input = label.find('input');

      if(input.is(':checked')){
        label.addClass('selected');
      }

      input.on('change', function(){
        var checked = input.is(':checked');
        toggleParentClass(input, labels, label, checked, 'selected');
      })
      .on('focus', function(){
        toggleParentClass(input, labels, label, true, 'focused');
      })
      .on('blur', function(){
        toggleParentClass(input, labels, label, false, 'focused');
      })
    });
  });
})();
