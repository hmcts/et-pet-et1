module.exports = (function () {

  $(function(){
    $('#navcontainer').on('click','.menu-trigger', function (e) {
      var el = $(e.currentTarget),
          $el = $(el);
      // show the right one.
      $el.find('span').toggleClass('arrow-down');
      $el.next().toggleClass('visuallyhidden');
    });
  });
})();
