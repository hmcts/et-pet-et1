/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
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
        if(input.is(':radio')){
            labels.removeClass('selected');
        }
        label.toggleClass('selected', checked);
      });
    });
  });
})();
