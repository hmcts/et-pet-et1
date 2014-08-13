// Reveals hidden hint text

module.exports = (function() {
  $('.hint-reveal').each(function(i, el){
    var trigger = $(el),
      content = trigger.parent().next('.toggle-content');
    trigger.on('click', function(){
      content.toggle();
    });
  });
})();
