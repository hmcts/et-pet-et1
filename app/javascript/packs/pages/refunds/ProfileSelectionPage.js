function setCurrentState() {
  let disabled = !selectedProfileTypeEl().val();
  $('.main-content.refunds_profile_selection [data-behavior=\'continue_button\']').prop('disabled', disabled);
}

function selectedProfileTypeEl() {
  return $('.main-content.refunds_profile_selection [data-behavior=\'profile_type\']:checked');
}

function profileTypeEl() {
  return $('.main-content.refunds_profile_selection [data-behavior=\'profile_type\']');
}

function updateStateWhenRequired() {
  profileTypeEl().on('click change', setCurrentState);
}

function RefundProfileSelectionPage() {
  setCurrentState();
  updateStateWhenRequired();
}
export default RefundProfileSelectionPage;

