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
    const {
      textContent: text,
      dataset: { value },
    } = event.target
    this.updateDisplay(value, text.trim())
    this.toggle()
  }

  clear(event) {
    event.stopPropagation()
    this.updateDisplay('', this.defaultLabelValue)
  }

  updateDisplay(value, labelText = this.getLabel(value)) {
    this.labelTarget.textContent = labelText
    this.inputTarget.value = value
    this.updateButtons(value)
    this.updateClearButton(value)
  }

  updateButtons(value) {
    this.buttonTargets.forEach((button) => {
      button.dataset.selected = value === button.dataset.value
    })
  }

  getLabel(value) {
    return (
      this.buttonTargets
        .find((option) => option.dataset.value === value)
        ?.textContent.trim() || this.defaultLabelValue
    )
  }

  updateClearButton(value) {
    if (!this.hasClearBtnTarget) {
      return
    }
    this.clearBtnTarget.classList.toggle('hidden', value === this.defaultValue)
  }
}
