import Dropdown from '@stimulus-components/dropdown'

export default class extends Dropdown {
  static targets = ['label', 'button', 'input', 'clearBtn']
  static values = {
    default: { type: String, default: '' },
    defaultLabel: { type: String, default: 'Select' },
  }

  connect() {
    super.connect()
    this.updateDisplay(this.defaultValue)
  }

  select(event) {
    const { textContent: text, value } = event.currentTarget
    this.updateDisplay(value, text.trim())
    this.toggle()
  }

  clear(event) {
    event.stopPropagation()
    this.updateDisplay(this.defaultValue)
  }

  updateDisplay(value, labelText = this.getLabel(value)) {
    this.labelTarget.textContent = labelText
    this.setInputValue(value)
    this.updateButtons(value)
    this.updateClearButton(value)
  }

  updateButtons(value) {
    this.buttonTargets.forEach((button) => {
      button.dataset.selected = value === button.value
    })
  }

  getLabel(value) {
    return (
      this.buttonTargets
        .find((option) => option.value === value)
        ?.textContent.trim() || this.defaultLabelValue
    )
  }

  updateClearButton(value) {
    if (!this.hasClearBtnTarget) {
      return
    }
    this.clearBtnTarget.classList.toggle('hidden', value === this.defaultValue)
  }

  setInputValue(value) {
    if (this.inputTarget.value === '') {
      this.inputTarget.value = value
      return
    }
    this.inputTarget.value = value
    this.inputTarget.dispatchEvent(new Event('change'))
  }
}
