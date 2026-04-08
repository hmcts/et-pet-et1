import { Controller } from "@hotwired/stimulus";

function updateContinueButton() {
  let disabled = !acceptDeclarationEl().is(":checked");
  $(".refunds_review .behavior-continue-button").prop("disabled", disabled);
}

function enableContinueWhenAllowed() {
  acceptDeclarationEl().on("click change", updateContinueButton);
}

function acceptDeclarationEl() {
  return $(".refunds_review [name='refunds_review[accept_declaration]']");
}

export default class extends Controller {
  connect() {
    updateContinueButton();
    enableContinueWhenAllowed();
  }
}
