// Manages session timeout & displays prompt prior to session expiry
import { Controller } from "@hotwired/stimulus";

const SECOND = 1000;
const MINUTE = 60 * SECOND;
const FIVE_MINUTES = 5 * MINUTE;
const FIFTY_FIVE_MINUTES = 55 * MINUTE;

export default class extends Controller {
  connect() {
    this.promptTimerRef = null;
    this.sessionTimerRef = null;
    this.setPromptExtendSessionClickEvent();
    this.resetSessionState();
  }

  disconnect() {
    clearInterval(this.promptTimerRef);
    clearTimeout(this.sessionTimerRef);
  }

  resetSessionState() {
    clearInterval(this.promptTimerRef);
    clearTimeout(this.sessionTimerRef);

    this.counter = FIVE_MINUTES;
    this.updateTimeLeftOnPrompt(this.counter);
    this.startSessionTimer();
  }

  startSessionTimer() {
    this.sessionTimerRef = setTimeout(() => {
      this.timeoutPrompt();
    }, FIFTY_FIVE_MINUTES);
  }

  setPromptExtendSessionClickEvent() {
    document.querySelector("#session_prompt_continue_btn").onclick = () => {
      this.refreshSession();
    };
  }

  timeoutPrompt() {
    this.promptTimerRef = setInterval(() => {
      this.promptUpdate();
    }, SECOND);
    this.togglePromptVisibility();
  }

  promptUpdate() {
    if (this.counter === 0) {
      this.expireSession();
    } else {
      this.counter -= SECOND;
      this.updateTimeLeftOnPrompt(this.counter);
    }
  }

  togglePromptVisibility() {
    const node = document.querySelector("#session_prompt");
    node.classList.toggle("govuk-!-display-none");
    node.classList.toggle("govuk-!-display-block");
  }

  updateTimeLeftOnPrompt(timeInMillis) {
    const seconds = timeInMillis / SECOND;
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    const time = mins === 0 ? secs : `${mins}:${this.padSeconds(secs)}`;
    document.querySelector("#session_prompt_time_left").innerHTML = time;
  }

  padSeconds(secs) {
    return String(secs).length === 1 ? `0${secs}` : secs;
  }

  expireSession() {
    location.href =
      location.protocol + "//" + location.host + "/apply/session/expired";
  }

  refreshSession() {
    clearInterval(this.promptTimerRef);

    fetch("/apply/session/touch", { credentials: "include" }).then(
      (response) => {
        if (!response.ok) {
          return;
        }

        this.togglePromptVisibility();
        this.resetSessionState();
      },
    );
  }
}
