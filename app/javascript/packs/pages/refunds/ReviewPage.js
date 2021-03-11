function updateContinueButton() {
  var disabled = !acceptDeclarationEl().is(':checked');
  $('.main-content.refunds_review [data-behavior=\'continue_button\']').prop('disabled', disabled);
}

function enableContinueWhenAllowed() {
  acceptDeclarationEl().on('click change', updateContinueButton);
}

function acceptDeclarationEl() {
  return $('.main-content.refunds_review [data-behavior=\'accept_declaration\']');
}

function RefundReviewPage() {
  updateContinueButton();
  enableContinueWhenAllowed();
}
export default RefundReviewPage;

