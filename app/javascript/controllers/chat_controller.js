import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "input", "messages", "ids"]

  attachSelection() {
    this.idsTarget.replaceChildren()
    document.querySelectorAll('input[data-selection-target="row"]:checked').forEach((box) => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "selected_ids[]"
      input.value = box.value
      this.idsTarget.append(input)
    })
  }

  toggle() {
    const opening = this.panelTarget.classList.contains("d-none")
    this.panelTarget.classList.toggle("d-none", !opening)
    this.buttonTarget.setAttribute("aria-expanded", opening)
    this.buttonTarget.setAttribute("aria-label", opening ? "Close chat" : "Open chat")

    if (opening) {
      this.inputTarget.focus()
      this.scrollToEnd()
    }
  }

  reset() {
    this.inputTarget.value = ""
    this.inputTarget.focus()
    this.scrollToEnd()
  }

  scrollToEnd() {
    const box = document.getElementById("chat_messages")
    box.scrollTop = box.scrollHeight
  }
}