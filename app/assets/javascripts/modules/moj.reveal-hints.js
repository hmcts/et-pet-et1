// Reveals hidden hint text

(function() {
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

(function() {
  $('.panel-indent input[type=radio]').each(function(i, field){
    var container = $(field);
    if(container.length){
      container.on('change', function(){
        var hint = $(this).parents('.panel-indent').children('.reveal-acas-hint');
        if(this.value == 'interim_relief' && this.checked) {
          hint.show();
        } else {
          hint.hide();
        }
      });
    }
  });
})();