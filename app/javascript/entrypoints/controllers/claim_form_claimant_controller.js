import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["otherTitle", "title", "allowPhoneOrVideoReason", "allowPhoneOrVideo"]
  values = {
    allowPhoneOrVideoAttendance: {
      type: Object,
      default: {
        phone: false,
        video: false
      }
    }
  }
  connect() {
    this.monitorChanges()
    this.showOrHideOtherTitle()
    this.showOrHidePhoneOrVideoReason()
  }

  disconnect() {
    this.unMonitorChanges()
  }

  showOrHideOtherTitle() {
    this.otherTitleTarget.hidden = this.titleTarget.value !== "Other"
    this.otherTitleTarget.querySelector('input').disabled = this.titleTarget.value !== "Other"
  }

  showOrHidePhoneOrVideoReason() {
    this.allowPhoneOrVideoReasonTarget.hidden = !this.allowPhoneOrVideoTarget.querySelector('input[type=checkbox][value=neither]').checked
  }

  allowPhoneOrVideoAttendanceCheckboxes() {
    return this.allowPhoneOrVideoTarget.querySelectorAll('input[type=checkbox]')
  }

  monitorChanges() {
    this.allowPhoneOrVideoAttendanceCheckboxes().forEach((checkbox) => {
      checkbox.addEventListener('change', this.phoneOrVideoCheckboxChange.bind(this))
    })
  }

  unMonitorChanges() {
    this.allowPhoneOrVideoAttendanceCheckboxes().forEach((checkbox) => {
      checkbox.removeEventListener('change', this.phoneOrVideoCheckboxChange.bind(this))
    })
  }

  phoneOrVideoCheckboxChange(event) {
    if (event.target.value === 'neither') {
      this.allowPhoneOrVideoAttendanceCheckboxes().forEach((checkbox) => {
        if (checkbox !== event.target && event.target.checked) {
          checkbox.checked = false
        }
        this.showOrHidePhoneOrVideoReason()
      })
    } else if (event.target.value !== 'neither' && event.target.checked) {
      this.allowPhoneOrVideoTarget.querySelector('input[value=neither]').checked = false
      this.showOrHidePhoneOrVideoReason()
    }
  }
}
