/*
* A polyfill that provides array.some method
* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some
*/
module.exports = (function(){
  if (!Array.prototype.some) {
    Array.prototype.some = function(fun /*, thisp */) {
      'use strict';

      if (this == null) {
        throw new TypeError();
      }

      var thisp, i,
          t = Object(this),
          len = t.length >>> 0;
      if (typeof fun !== 'function') {
        throw new TypeError();
      }

      thisp = arguments[1];
      for (i = 0; i < len; i++) {
        if (i in t && fun.call(thisp, t[i], i, t)) {
          return true;
        }
      }

      return false;
    };
  }
})();