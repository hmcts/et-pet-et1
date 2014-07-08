<<<<<<< HEAD
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var create = require('./polyfills/polyfill.object-create'),
    reveal = require('./modules/moj.reveal'),
    checkbox = require('./modules/moj.checkbox-toggle');
},{"./modules/moj.checkbox-toggle":2,"./modules/moj.reveal":3,"./polyfills/polyfill.object-create":4}],2:[function(require,module,exports){
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
      if (arguments.length != 1) {
          throw new Error('Object.create implementation only accepts one parameter.');
      }
      F.prototype = o
        return new F()
    }
  })()
}
})();
},{}]},{},[1])
=======
!function e(t,n,o){function r(c,l){if(!n[c]){if(!t[c]){var u="function"==typeof require&&require;if(!l&&u)return u(c,!0);if(i)return i(c,!0);throw new Error("Cannot find module '"+c+"'")}var a=n[c]={exports:{}};t[c][0].call(a.exports,function(e){var n=t[c][1][e];return r(n?n:e)},a,a.exports,e,t,n,o)}return n[c].exports}for(var i="function"==typeof require&&require,c=0;c<o.length;c++)r(o[c]);return r}({1:[function(e){e("./polyfills/polyfill.object-create"),e("./modules/moj.reveal"),e("./modules/moj.checkbox-toggle")},{"./modules/moj.checkbox-toggle":2,"./modules/moj.reveal":3,"./polyfills/polyfill.object-create":4}],2:[function(e,t){t.exports=function(){var e={init:function(){$(".form-group-checkbox-toggle").each(function(t,n){var o=$(n).find("label");e.bindCheckboxes(o)})},bindCheckboxes:function(e){var t=$(document.getElementById(e.attr("data-target"))),n=function(){return e.find("input").is(":not(:checked)")},o=t.find("label");e.on("click",function(){o.toggleClass("disabled",n()).find("input").attr("disabled",n())})}};return e.init(),e}()},{}],3:[function(e,t){t.exports=function(){var e={group:".form-group-reveal",data:"[data-trigger]",label:".block-label",content:"toggle-content",selected:"selected"},t={init:function(n){"undefined"!=typeof n&&(e=n),$(e.group).each(function(e,n){t.bindLabels(n)})},bindLabels:function(n){var o=$(n).find(e.label),r=$(document.getElementById(n.getAttribute("data-trigger"))),i=(r.parent("label"),$(n).next(".toggle-content"));$(o).on("click",function(){t.toggleState(o,i)})},toggleState:function(t,n){return t.each(function(t,o){var r=$(o).find("input"),i=r.is(":checked");r.attr("checked",i).parent().toggleClass(e.selected,i),i?n.show():n.hide()})}};return t.init(),t}()},{}],4:[function(e,t){t.exports=function(){Object.create||(Object.create=function(){function e(){}return function(t){if(1!=arguments.length)throw new Error("Object.create implementation only accepts one parameter.");return e.prototype=t,new e}}())}()},{}]},{},[1]);
>>>>>>> added jeet and minor styling in prep for user testing
