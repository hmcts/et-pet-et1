module.exports = (function () {

  var navAlert = {},
    initialValues;

  navAlert.getValues = function() {
    return $('.form-fields').find('.form-control')
      .map(function() {
        return this.value;
      })
      .toArray();
  };

  navAlert.checkDiff = function() {
    var currentValues = navAlert.getValues(),
      isSame = (initialValues.length == currentValues.length) && initialValues.every(function(element, index) {
      return element === currentValues[index];
    });
    return isSame;
  };

  navAlert.init = function() {

    initialValues = navAlert.getValues();

    var alertPopUp = $('#form-summary').hide(),
    nextPage,
    notDifferent;

    $('#steps-list').on('click','a', function (e) {
      e.preventDefault();
      nextPage = this.href;
      notDifferent = navAlert.checkDiff();

      if(notDifferent) {
        window.location = nextPage;
      } else {
        alertPopUp
        .removeClass('hidden')
        .show()
        .get(0).scrollIntoView();
      }

    });

    $('#button-go').on('click', function(){
      window.location = nextPage;
    });

    $('#button-stay').on('click', function(){
      $("#form-actions").get(0).scrollIntoView();
    });

  };

  navAlert.init();

  return navAlert;

})();
