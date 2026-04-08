import { Controller } from "@hotwired/stimulus";
import { Components } from "et_gds_design_system";
const { DropzoneUploader } = Components;

export default class extends Controller {
  connect() {
    DropzoneUploader.init();
  }
}
