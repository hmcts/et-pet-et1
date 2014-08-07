// Toggles disabled groups of adjacent checkboxes

module.exports = (function() {
  var root = $('.related-checkboxes-root'),
    collections = $('.related-checkboxes-collection');

  collections.each(function(i, collection){
    var selected = [],
      checkboxes = $(collection).find('input');
    //
    checkboxes.on('change', function(){

    });
  });

})();