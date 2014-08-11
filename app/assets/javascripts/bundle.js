(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var create = require('./polyfills/polyfill.object-create'),
    reveal = require('./modules/moj.reveal'),
    checkboxToggle = require('./modules/moj.checkbox-toggle'),
    selectedOption = require('./modules/moj.selected-option'),
    checkboxReveal = require('./modules/moj.checkbox-reveal');
},{"./modules/moj.checkbox-reveal":2,"./modules/moj.checkbox-toggle":3,"./modules/moj.reveal":4,"./modules/moj.selected-option":5,"./polyfills/polyfill.object-create":6}],2:[function(require,module,exports){
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

},{}],5:[function(require,module,exports){
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
},{}],6:[function(require,module,exports){
/*
* A polyfill that provides Object.create method
* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create
*/
module.exports = (function(){
  if (!Object.create) {
  Object.create = (function(){
    function F(){}

    return function(o){
      if (arguments.length !== 1) {
          throw new Error('Object.create implementation only accepts one parameter.');
      }
      F.prototype = o;

      return new F();
    };
  })();
}
})();

},{}]},{},[1])