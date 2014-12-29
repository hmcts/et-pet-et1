/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true */
/*global moj, $ */
// General utilities for MOJ
// Dependencies: moj, jQuery
module.exports = (function() {

  "use strict";

  var datePicker = {};

  datePicker.init = function (el) {
    var native_date = el ? el : $('.js-native-date'),
      fields = native_date.find('.datefield'),
      datefields = native_date.find('.datefield input'),
      hint = native_date.find('.datefield-hint'),
      native_dateinput = native_date.find('.js-native-date__date-input');

    if (datePicker.isNativeDate()) {
      datePicker.useNativeDate(datefields, native_dateinput);
      native_dateinput
        .add(datefields)
        .add(hint)
        .add(fields)
        .toggleClass('hidden');
    } else {
      datePicker.useDateFields(datefields, native_dateinput);
    }

  };

  datePicker.useDateFields = function(datefields, native_dateinput){
    datefields.on('change', function(){
      native_dateinput.val(datefields.map(function(index, el){
        return el.value;
      }).get().join('-'));
    });
  };

  datePicker.useNativeDate = function(datefields, native_dateinput){
    native_dateinput.on('change', function(){
      var dateParts = $(this).val().split('-'),
      month = parseInt(dateParts[1]),
      day = parseInt(dateParts[2]);
      datefields.filter('.year').val(dateParts[0]);
      datefields.filter('.month').val((isNaN(month) ? '' : month));
      return datefields.filter('.day').val((isNaN(day) ? '' : day));
    });
  };

  datePicker.isNativeDate = function () {
    return Modernizr.inputtypes.date && Modernizr.touch;
  };

  datePicker.init();

  return datePicker;

}());
