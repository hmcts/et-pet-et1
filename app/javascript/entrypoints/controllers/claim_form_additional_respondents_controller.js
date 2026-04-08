import { Controller } from "@hotwired/stimulus";
import RemoveMultiple from "../components/RemoveMultiple";

function setupRemoveMoreThan4AdditionalRespondents() {
  document.addEventListener("click", function (e) {
    if (!e.target.matches("a[data-multiple-remove]")) {
      return;
    }

    removeMoreThan4AdditionalRespondentsText();
  });
}

function removeMoreThan4AdditionalRespondentsText() {
  const element = document.querySelector(
    "*[data-multiple-respondent-re-enable]",
  );
  element.remove();
}

function setupRemoveMultiple() {
  RemoveMultiple();
}

export default class extends Controller {
  connect() {
    setupRemoveMoreThan4AdditionalRespondents();
    setupRemoveMultiple();
  }
}
