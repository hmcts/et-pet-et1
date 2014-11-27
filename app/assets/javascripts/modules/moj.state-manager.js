module.exports = (function () {

  $(function(){
    $('#navcontainer').on('click','.menu-trigger', function (e) {
      var el = $(e.currentTarget);
      // show the right one.
      $(el).next().toggleClass('visuallyhidden');
    });
  });


// $.subscribe('/device/change/', function (event, state) {
//   console.log(event.type, state);
// });

// // Going smaller
// $.subscribe('/device/move/desktop/to/tablet/', function (event, state) {
//   console.log(event.type, state);
// });

// $.subscribe('/device/move/tablet/to/mobile/', function (event, state) {
//   console.log(event.type, state);
// });

// // Going bigger
// $.subscribe('/device/move/mobile/to/tablet/', function (event, state) {
//   console.log(event.type, state);
// });


// $.subscribe('/device/move/tablet/to/desktop/', function (event, state) {
//   console.log(event.type, state);
// });

})();
