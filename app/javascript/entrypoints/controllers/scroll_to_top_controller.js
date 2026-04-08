import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  scroll() {
    window.scrollTo({ top: 0 });
  }
}
