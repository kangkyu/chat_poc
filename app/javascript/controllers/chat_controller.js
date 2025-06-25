import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "messageInput", "sendButton", "loading", "fileUpload", "selectedFile", "fileName"]

  connect() {
    this.scrollToBottom()
  }

  showLoading() {
    this.loadingTarget.classList.remove("hidden")
    this.sendButtonTarget.disabled = true
    this.scrollToBottom()
  }

  hideLoading() {
    this.loadingTarget.classList.add("hidden")
    this.sendButtonTarget.disabled = false
    this.messageInputTarget.value = ""
    this.messageInputTarget.style.height = "auto"
    this.removeFile()
    this.scrollToBottom()
  }

  autoResize() {
    const input = this.messageInputTarget
    input.style.height = "auto"
    input.style.height = Math.min(input.scrollHeight, 120) + "px"
  }

  handleEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.querySelector("#chat-form").requestSubmit()
    }
  }

  toggleFileUpload() {
    this.fileUploadTarget.classList.toggle("hidden")
  }

  fileSelected(event) {
    if (event.target.files.length > 0) {
      const file = event.target.files[0]
      this.fileNameTarget.textContent = file.name
      this.selectedFileTarget.classList.remove("hidden")
      this.fileUploadTarget.classList.add("hidden")
    }
  }

  removeFile() {
    const fileInput = this.element.querySelector("#file-input")
    fileInput.value = ""
    this.selectedFileTarget.classList.add("hidden")
    this.fileUploadTarget.classList.add("hidden")
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
