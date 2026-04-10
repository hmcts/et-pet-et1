import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["success", "failure"];
  monitorDownloadLink() {
    const successNode = this.successTarget;
    const failureNode = this.failureTarget;
    if (!successNode) {
      return;
    }

    const url = successNode.getAttribute("href");
    const http = new XMLHttpRequest();
    http.overrideMimeType("application/pdf");
    http.open("GET", url, true);
    http.onload = () => {
      if (http.readyState === 4) {
        if (http.status === 200) {
          failureNode.classList.add("hidden");
          successNode.classList.remove("hidden");
        } else {
          failureNode.classList.remove("hidden");
          successNode.classList.add("hidden");
          console.warn(
            "Unable to find PDF, retrying " + url + " in 10 seconds",
          );

          this.disconnectTimeout();
          this.timeout = setTimeout(this.boundMonitorDownloadLink, 10000);
        }
      }
    };
    http.send();
  }
  connect() {
    this.boundMonitorDownloadLink = this.monitorDownloadLink.bind(this);
    this.monitorDownloadLink();
  }
  disconnect() {
    this.disconnectTimeout();
  }
  disconnectTimeout() {
    if (!this.timeout) {
      return;
    }

    clearTimeout(this.timeout);
  }
}
