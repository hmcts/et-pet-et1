(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var create = require('./polyfills/polyfill.object-create'),
    reveal = require('./modules/moj.reveal'),
    checkbox = require('./modules/moj.checkbox-toggle');
},{"./modules/moj.checkbox-toggle":2,"./modules/moj.reveal":3,"./polyfills/polyfill.object-create":4}],2:[function(require,module,exports){
// Reveals hidden content

module.exports = (function() {
  var checkboxToggle = {
    init: function() {
      $('.form-group-checkbox-toggle').each(function(i, el) {
        var label = $(el).find('label');
        checkboxToggle.bindCheckboxes(label);
      });
    },
    bindCheckboxes: function(checkbox) {
      var target = $(document.getElementById(checkbox.attr('data-target'))),
        checked = function(){
          return checkbox.find('input').is(':not(:checked)');
        },
        slaves = target.find('label');

      checkbox.on('click', function(){
        slaves.toggleClass('disabled', checked())
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
  var config = {
      group: '.form-group-reveal',
      data: '[data-target]',
      label: '.block-label',
      content: 'toggle-content',
      selected: 'selected'
    },
    reveal = {
      init : function(conf){
        if(typeof conf !== 'undefined'){
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

},{}],4:[function(require,module,exports){
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