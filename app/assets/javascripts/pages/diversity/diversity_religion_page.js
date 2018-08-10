var diversityReligionPage = (function(){
  var diversityReligionPage = {};

  function subscribeToReligionSwitch(){
    $('input[name="diversities_religion[religion]"][type="radio"]').change('change', function(e){
      var selected = $(this).attr('id');

      if(selected == 'diversities_religion_religion_any-other-religion'){
        showReligionTextField();
      } else {
        hideReligionTextField();
      }
    });
  }

  function showReligionTextField() {
    $('div.field_with_hint, .field_with_hint input').show();
  };

  function hideReligionTextField() {
    $('div.field_with_hint, .field_with_hint input').hide();
    $('.field_with_hint input').val('');
  };

  function isInReview(){
    if(location.search == '?return_to_review=true'){
      return true;
    }
  }

  diversityReligionPage.init = function(value) {
    console.log(isInReview())
    if(!isInReview()){
      hideReligionTextField();
    }
    subscribeToReligionSwitch();
  };
  return diversityReligionPage;

})();