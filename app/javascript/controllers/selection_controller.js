import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["all", "row", "action"]

  rowTargetConnected() {
    this.update()
  }

  rowTargetDisconnected() {
    this.update()
  }

  connect() {
    this.update()
  }

  toggleAll() {
    this.rowTargets.forEach((row) => (row.checked = this.allTarget.checked))
    this.update()
  }

  update() {
    if (!this.hasAllTarget) return

    const total = this.rowTargets.length
    const selected = this.rowTargets.filter((row) => row.checked).length

    this.allTarget.checked = total > 0 && selected === total
    this.allTarget.indeterminate = selected > 0 && selected < total
    this.allTarget.disabled = total === 0

    this.actionTargets.forEach((button) => (button.disabled = selected === 0))
  }
}