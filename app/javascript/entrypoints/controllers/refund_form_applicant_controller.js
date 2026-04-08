import { Controller } from "@hotwired/stimulus";

function selectedOptionEl() {
  return $(
    ".refunds_applicant [name='refunds_applicant[has_name_changed]']:checked",
  );
}

function enableContinueWhenAllowed() {
  $(".refunds_applicant [name='refunds_applicant[has_name_changed]']").on(
    "change",
    setCurrentState,
  );
}

function continueButtonEl() {
  return $(".refunds_applicant .behavior-continue-button");
}

function setCurrentState() {
  let val = selectedOptionEl().val();
  continueButtonEl().prop("disabled", val !== "false");
}

export default class extends Controller {
  connect() {
    setCurrentState();
    enableContinueWhenAllowed();
  }
}
