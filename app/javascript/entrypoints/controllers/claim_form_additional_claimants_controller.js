import { Controller } from "@hotwired/stimulus";
import RemoveMultiple from "../components/RemoveMultiple";

export default class extends Controller {
  connect() {
    RemoveMultiple();
  }
}
