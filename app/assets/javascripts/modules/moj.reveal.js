// Reveals hidden content

module.exports = (function() {
  var config = {
      group: '.form-group-reveal',
      data: '[data-trigger]',
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
        var labels = $(group).find(config.label),
            input = $(document.getElementById(group.getAttribute('data-trigger'))),
            trigger = input.parent('label'),
            target = $(group).next('.toggle-content');

        $(labels).on('click', function(event){
          reveal.toggleState(labels, target);
        });
      },
      toggleState: function(labels, target) {
        var checked;

        return labels.each(function(i, label){
          var input = $(label).find('input'),
            checked = input.is(':checked');

          input.attr('checked', checked)
            .parent().toggleClass(config.selected, checked);

          if(checked){
            target.show();
          } else {
            target.hide();
          }

        });
      }
    };

  reveal.init();

  return reveal;

})();