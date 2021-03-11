import $ from 'jquery';
function selectedOptionEl() {
  return $('.main-content.refunds_applicant [name=\'refunds_applicant[has_name_changed]\']:checked');
}

function enableContinueWhenAllowed() {
  $('.main-content.refunds_applicant [name=\'refunds_applicant[has_name_changed]\']').on('change', setCurrentState)
}

function continueButtonEl() {
  return $('.main-content.refunds_applicant [data-behavior=\'continue_button\']');
}

function setCurrentState() {
  let val = selectedOptionEl().val()
  continueButtonEl().prop('disabled', val !== 'false');
}

function RefundApplicantPage() {
  setCurrentState();
  enableContinueWhenAllowed();
};
export default RefundApplicantPage;
