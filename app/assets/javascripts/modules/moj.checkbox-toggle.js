/* Toggles disabled groups of adjacent checkboxes
* assumes structure: .related-checkboxes-root + .related-checkboxes-collection
*/
module.exports = (function() {
<<<<<<< HEAD
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
=======
  var root = $('.related-checkboxes-root'),
    collections = $('.related-checkboxes-collection');

  collections.each(function(i, collection){
    var selected = [],
      checkboxes = $(collection).find('input');
    //
    checkboxes.on('change', function(){

    });
>>>>>>> b443d2c... updated related checkbox layout
  });

})();