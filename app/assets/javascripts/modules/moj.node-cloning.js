module.exports = (function() {
  var cloneSection = function(section) {
    var clone    = section.clone(),
        span     = $('span.index', clone),
        inputs   = $('input', clone);

    span.text(parseInt(span.text(), 10) + 1);
    inputs.val('');
    inputs.each(incrementAttrs);
    clone.insertAfter(section);
  }

  var incrementAttrs = function(_, input) {
    var oldId = input.id;
    var id    = oldId.replace(/_(\d+)_/, function(_, i) {
      return '_' + (parseInt(i, 10) + 1) + '_'
    });

    input = $(input);

    var name = input.attr('name').replace(/\[(\d+)\]/, function(_, i) {
      return '[' + (parseInt(i, 10) + 1) + ']'
    });

    input.attr('name', name);
    input.attr('id', id);
  }

  $('input[type=number].toggle').show().bind('change', function(event) {
    var selector = $(event.target).data('target');

    while($('.' + selector).size() < event.target.value) {
      cloneSection($('.' + selector).last());
    }

    while($('.' + selector).size() > event.target.value) {
      $('.' + selector).last().remove();
    }
  });
})();
