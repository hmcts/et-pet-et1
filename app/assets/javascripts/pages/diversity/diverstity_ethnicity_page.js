var diversityEthinicityPage = (function(){
    var diversityEthinicityPage = {};

    function subscribeToEthnicitySwitch(){
      $('select#diversity_ethnicity').change('change', function(e){
        hide_subgroups();
        var selected = $(this).val();
        $("*[data-name='"+selected+"']").show();
      })
    }

    function show_selected_subgroup(){
      var selected = $('select#diversity_ethnicity').val();
      $("*[data-name='"+selected+"']").show();
    }

    function hide_subgroups(){
      $('fieldset.ethnicity_subgroup').hide();
      resetSelections();
    }

    function resetSelections(){
      var subgroup_value = $('#diversity_ethnicity_subgroup').val();
      $('fieldset.ethnicity_subgroup select').each(function(i, element) {
        if($(element).val() !== subgroup_value){
          $(element).val('');
        }
      });
      $('#diversity_ethnicity_subgroup').val('')
    }

    diversityEthinicityPage.init = function() {
      hide_subgroups();
      subscribeToEthnicitySwitch();
      show_selected_subgroup();
    };
    return diversityEthinicityPage;
})();
