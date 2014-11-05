/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
  'use strict';

  var isMultiples = $(document.body).hasClass('multiples');

  if(isMultiples) {
      var link = $('.remove-claimant');
      console.log(link.length);
  }
})();
