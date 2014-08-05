/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
  $('.options').each(function(i, container){
    var blocklabels = $(container).find('.block-label'),
      labels = blocklabels.find('label');

    labels.each(function(i, el){
      var checked,
        label = $(el),
        input = label.find('input');
      label.on('click', function(){
        checked = input.is(':checked');
        labels.removeClass('selected')
        .a
        label.toggleClass('selected', checked);
      });
    });
  });
})();