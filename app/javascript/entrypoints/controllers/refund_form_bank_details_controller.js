import { Controller } from "@hotwired/stimulus";

function publishCurrentAccountType() {
  let val = $(
    ".refunds_bank_details [name='refunds_bank_details[payment_account_type]']:checked",
  ).val();
  setContinueButtonDisabled(val);
}

function setContinueButtonDisabled(val) {
  $(".refunds_bank_details .behavior-continue-button").prop(
    "disabled",
    val === "" || val === undefined,
  );
}

function enableContinueWhenAllowed() {
  $(
    ".refunds_bank_details [name='refunds_bank_details[payment_account_type]']",
  ).on("change", publishCurrentAccountType);
}

export default class extends Controller {
  connect() {
    enableContinueWhenAllowed();
    publishCurrentAccountType();
  }
}
