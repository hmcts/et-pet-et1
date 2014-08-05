// Reveals hidden content

module.exports = (function() {
  var reveal = {
    init : function() {
      $('.form-group-reveal').each(function(i, group) {
        reveal.bindLabels(group);
      });
    },
    bindLabels: function(container) {
      var blocklabels = $(container).find('.block-label'),
        labels = blocklabels.find('label');

      labels.each(function(i, label){
        $(label).on('click', function(event){
          reveal.toggleState(labels);
        });
      });
    },
    toggleState: function(labels, target) {
      var checked;

      return labels.each(function(i, label){
        var input = $(label).find('input'),
          target = $(document.getElementById(input.attr('data-target'))),
          checked = input.is(':checked');

        if(checked) {
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
