import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'item']

  connect() {
    this.updateItems(this.inputTarget.value)
  }

  change(event) {
    const value = event.currentTarget.value
    this.inputTarget.value = value
    this.updateItems(value)
  }

  updateItems(value) {
    value = value.trim() == "" ? this.itemTargets[1].value : value
    this.itemTargets.forEach((item) => {
      item.hidden = item.value === value
    })
  }
}
