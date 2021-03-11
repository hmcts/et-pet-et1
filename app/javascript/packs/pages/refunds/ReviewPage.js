function updateContinueButton() {
  var disabled = !acceptDeclarationEl().is(':checked');
  $('.refunds_review [data-behavior=\'continue_button\']').prop('disabled', disabled);
}

function enableContinueWhenAllowed() {
  acceptDeclarationEl().on('click change', updateContinueButton);
}

function acceptDeclarationEl() {
  return $(".refunds_review [name='refund_review[accept_declaration]']");
}

function RefundReviewPage() {
  updateContinueButton();
  enableContinueWhenAllowed();
}
export default RefundReviewPage;

