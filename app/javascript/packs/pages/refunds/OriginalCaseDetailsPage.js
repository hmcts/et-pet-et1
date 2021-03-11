function OriginalCaseDetailsPage() {
  function publishCurrentAddressChanged() {
    let val = $('.main-content.refunds_original_case_details [name=\'refunds_original_case_details[address_changed]\']:checked').val();
    $.publish('address_changed', val);
  }
  function publishCurrentHadRepresentative() {
    let val = $('.main-content.refunds_original_case_details [name=\'refunds_original_case_details[claim_had_representative]\']:checked').val();
    $.publish('claim_had_representative', val);
  }
  function publishCurrentValues() {
    publishCurrentAddressChanged();
    publishCurrentHadRepresentative();
  }
  publishCurrentValues();
}
export default OriginalCaseDetailsPage;
