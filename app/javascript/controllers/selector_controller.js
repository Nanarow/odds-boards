import Dropdown from '@stimulus-components/dropdown'

export default class extends Dropdown {
  static targets = ['label', 'button', 'input', 'clearBtn']
  static values = {
    default: String,
  }
  DEFAULT_VALUE = ''
  DEFAULT_LABEL = 'Select'

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
    this.updateDisplay(this.DEFAULT_VALUE, this.DEFAULT_LABEL)
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
        ?.textContent.trim() || this.DEFAULT_LABEL
    )
  }

  updateClearButton(value) {
    if (!this.hasClearBtnTarget) {
      return
    }
    this.clearBtnTarget.classList.toggle('hidden', value === this.DEFAULT_VALUE)
  }
}
