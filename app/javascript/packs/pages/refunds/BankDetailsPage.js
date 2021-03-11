function publishCurrentAccountType() {
  let val = $('.main-content.refunds_bank_details [name=\'refunds_bank_details[payment_account_type]\']').val();
  $.publish('payment_account_type', val);
}

function publishCurrentValues() {
  publishCurrentAccountType();
}


function enableContinueWhenAllowed() {
  $.subscribe('payment_account_type', function (event, val) {
    $('.main-content.refunds_bank_details [data-behavior=\'continue_button\']').prop('disabled', val === '');
  });
}

function RefundBankDetailsPage() {
  enableContinueWhenAllowed();
  publishCurrentValues();
}

export default RefundBankDetailsPage;
