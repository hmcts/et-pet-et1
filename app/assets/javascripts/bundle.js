(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var reveal = require('./modules/moj.reveal'),
  checkboxToggle = require('./modules/moj.checkbox-toggle'),
  selectedOption = require('./modules/moj.selected-option'),
  checkboxReveal = require('./modules/moj.checkbox-reveal'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  nodeCloning    = require('./modules/moj.node-cloning');

},{"./modules/moj.checkbox-reveal":2,"./modules/moj.checkbox-toggle":3,"./modules/moj.node-cloning":4,"./modules/moj.reveal":6,"./modules/moj.reveal-hints":5,"./modules/moj.selected-option":7}],2:[function(require,module,exports){
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
},{}],3:[function(require,module,exports){
/* Toggles disabled groups of adjacent checkboxes
* assumes structure: .related-checkboxes-root + .related-checkboxes-collection
*/
module.exports = (function() {
  var rootCheckbox = $('.related-checkboxes-root'),
    toggleRootCheckbox = function(array, root) {
      var checkbox = root.find('input');
      return checkbox.prop({
        checked : array.length
      });
    },
    toggleCheckboxes = function(checked, array, val) {
      if(checked){
        return array.push(val);
      } else {
        return array.pop(array.indexOf(val));
      }
    };

  rootCheckbox.each(function(i, root) {
    var main = $(root),
      collection = main.next('.related-checkboxes-collection'),
      selectedArray = [],
      checkboxes = collection.find('input');

    main.on('change', function(){
      var checked = main.is(':checked');
      if(!checked){
        $.each(selectedArray, function(i,val){
          $(checkboxes[val]).prop('checked' , false);
        });
        selectedArray = [];
      }
    });

    checkboxes.each(function(index, el) {
      var checked,
        checkbox = $(el);
      checkbox.on('change', function() {
        checked = checkbox.is(':checked');
        toggleCheckboxes(checked, selectedArray, index);
        toggleRootCheckbox(selectedArray, main);
      });
    })
  });

})();

},{}],4:[function(require,module,exports){
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

},{}],5:[function(require,module,exports){
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
},{}],6:[function(require,module,exports){
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

},{}],7:[function(require,module,exports){
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
      input.on('change', function(){
        var checked = input.is(':checked');
        labels.removeClass('selected');
        label.toggleClass('selected', checked);
      });
    });
  });
})();
},{}]},{},[1])