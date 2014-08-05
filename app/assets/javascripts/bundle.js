(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var create = require('./polyfills/polyfill.object-create'),
    reveal = require('./modules/moj.reveal'),
    checkbox = require('./modules/moj.checkbox-toggle'),
    selectedOption = require('./modules/moj.selected-option');
},{"./modules/moj.checkbox-toggle":2,"./modules/moj.reveal":3,"./modules/moj.selected-option":4,"./polyfills/polyfill.object-create":5}],2:[function(require,module,exports){
// Toggles disabled groups of adjacent checkboxes

module.exports = (function() {
  var checkboxToggle = {
    init: function() {
      $('.form-group-checkbox-toggle').each(function(i, el) {
        var label = $(el).find('label');
        checkboxToggle.bindCheckboxes(label);
      });
    },
    bindCheckboxes: function(label) {
      var input = label.find('input'),
        target = $(document.getElementById(input.attr('data-target'))),
        checked = function(){
          return input.is(':not(:checked)');
        },
        checkboxes = target.find('label');

      input.on('click', function(){
        checkboxes.toggleClass('disabled', checked())
          .find('input').attr('disabled', checked());
      });
    }
  };

  checkboxToggle.init();

  return checkboxToggle;

})();
},{}],3:[function(require,module,exports){
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

},{}],4:[function(require,module,exports){
/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
  $('.options').each(function(i, container){
    var blocklabels = $(container).find('.block-label'),
      labels = blocklabels.find('label');

    labels.each(function(i, el){
      var checked,
        label = $(el),
        input = label.find('input');
      label.on('click', function(){
        checked = input.is(':checked');
        labels.removeClass('selected')
        .a
        label.toggleClass('selected', checked);
      });
    });
  });
})();
},{}],5:[function(require,module,exports){
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