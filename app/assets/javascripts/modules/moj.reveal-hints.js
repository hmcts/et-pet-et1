// Reveals hidden hint text

module.exports = (function() {
  $('.field_with_hint').each(function(i, field){
    var container = $(field),
      trigger = container.find('.hint-reveal');
    if(container.length){
      var content = container.find('.toggle-content');
      trigger.on('click', function(){
        content.toggle();
      });
    }
  });
})();