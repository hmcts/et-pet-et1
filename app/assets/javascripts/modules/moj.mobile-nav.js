module.exports = (function () {

  $(function(){
    $('#navcontainer').on('click','.menu-trigger', function (e) {
      $(e.currentTarget)
      .toggleClass('active')
      .next().toggle();
    });
  });

})();
