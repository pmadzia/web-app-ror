// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.set_selection = function () {
  const ids = this.templateContent.textContent.split(",").filter(Boolean)
  const rows = document.querySelectorAll('input[data-selection-target="row"]')

  rows.forEach((box) => { box.checked = ids.includes(box.value) })
  rows[0]?.dispatchEvent(new Event("change", { bubbles: true }))
}
