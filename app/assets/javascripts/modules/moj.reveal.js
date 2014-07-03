// Reveals hidden content

module.exports = (function() {
  var config = {
      group: '.form-group-reveal',
      data: '[data-target]',
      label: '.block-label',
      content: 'toggle-content',
      selected: 'selected'
    },
    reveal = {
      init : function(conf){
        if(typeof conf != 'undefined'){
          config = conf;
        }
        $(config.group).each(function(i, el) {
          reveal.bindLabels(el);
        });
      },
      bindLabels: function(group) {
        var label = config.label,
          labels = $(group).find(label);

        $(group).on('click', label , function(event){
          reveal.toggleState(labels);
        });
      },
      toggleState: function(labels) {
        var checked;

        return labels.each(function(i, label){
          var input = $(label).find('input'),
            checked = input.is(':checked'),
            target = $(document.getElementById(label.getAttribute('data-target')));

          input.attr('checked', checked)
            .parent().toggleClass(config.selected, checked);

          if(checked){
            target.removeClass(config.content);
          } else {
            target.addClass(config.content);
          }

        });
      }
    };

  reveal.init();

  return reveal;

})();