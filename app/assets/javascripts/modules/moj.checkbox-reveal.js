/* Toggles content if checkbox is checked
*/
module.exports = (function() {
  $('.reveal-checkbox').each(function(i, container){
    var input = $(container).find('.input-reveal');
    input.change(function(){
      var checked = input.is(':checked');
      $(container).next('.panel-indent').toggleClass('toggle-content', !checked);
    });
  });
})();
