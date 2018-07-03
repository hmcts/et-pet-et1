var diversityEthinicityPage = (function(){
    var diversityEthinicityPage = {};

    function subscribeToEthnicitySwitch(){
      $('.diversities_ethnicity_ethnicity input[type="radio"]').change('change', function(e){
        hide_subgroups();
        resetSelections();

        var selected = parameterize($(this).val());
        $("fieldset."+selected).show();
      })
    }

    function show_selected_subgroup(){
      var checked_value = $('input[name="diversities_ethnicity[ethnicity]"]:checked').val();
      var selected = parameterize(checked_value);
      $("fieldset."+selected).show();
    }

    function hide_subgroups(){
      $('fieldset.ethnicity_subgroup').hide();
    }

    function resetSelections(){
      $('fieldset.ethnicity_subgroup input:checked').each(function(i, element) {
        $(element).prop('checked', false)
      });
    }

    function parameterize(value){
      var selected = value.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'');
      return selected;
    }

    diversityEthinicityPage.init = function() {
      hide_subgroups();
      subscribeToEthnicitySwitch();
      show_selected_subgroup();
    };
    return diversityEthinicityPage;
})();
