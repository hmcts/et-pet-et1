import { Controller } from "@hotwired/stimulus";

function setCurrentState() {
  let disabled = !selectedProfileTypeEl().val();
  $(".refunds_profile_selection .behavior-continue-button").prop(
    "disabled",
    disabled,
  );
}

function selectedProfileTypeEl() {
  return $(
    'input[type=radio][name="refunds_profile_selection[profile_type]"]:checked',
  );
}

function profileTypeEl() {
  return $('input[type=radio][name="refunds_profile_selection[profile_type]"]');
}

function updateStateWhenRequired() {
  profileTypeEl().on("click change", setCurrentState);
}

export default class extends Controller {
  connect() {
    setCurrentState();
    updateStateWhenRequired();
  }
}
