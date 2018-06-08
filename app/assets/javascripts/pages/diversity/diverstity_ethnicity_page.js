var diversityEthinicityPage = (function() {
    var diversityEthinicityPage = {};

    function subscribeToEthnicitySwitch() {
      $('select#diversity_ethnicity').change('change', function(e){
        hide_subgroups();
        var selected = $(this).val();
        $(`*[data-name='${selected}']`).show()
      })
    }

    function hide_subgroups(){
      $('fieldset.ethnicity_subgroup').hide()
      resetSelections()
    }

    function resetSelections(){
      $('fieldset.ethnicity_subgroup select').each(function(i, element) {
        $(element).val('')
      });
    }

    diversityEthinicityPage.init = function() {
      hide_subgroups();
      subscribeToEthnicitySwitch();
    };
    return diversityEthinicityPage;
})();
