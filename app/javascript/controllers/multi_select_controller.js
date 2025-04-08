import Dropdown from '@stimulus-components/dropdown'

export default class MultiSelectController extends Dropdown {
  static targets = ['list', 'input', 'select', 'option', 'options']
  static values = {
    default: { type: Array, default: [] },
    placeholder: { type: String, default: 'Select' },
    options: { type: Array, default: [] },
  }
  DEFAULT_VALUE = ''

  connect() {
    super.connect()
    this.selectedValues = []
    this.defaultValue.forEach((value) => this.add(value))
  }

  scroll() {
    this.menuTarget.scrollIntoView({
      behavior: 'smooth',
      block: 'center',
      inline: 'nearest',
    })
  }

  addByInput(event) {
    event.preventDefault()
    this.add(event.target.value)
  }

  addByOption(event) {
    this.add(event.target.textContent)
  }

  add(value) {
    value = value.trim()
    if (!this.isValueExist(value)) {
      this.selectedValues.push(value)
      this.selectTarget.append(new Option(value, value, false, true))
      this.listTarget.append(this.createOption(value))
    }
    this.inputTarget.value = this.DEFAULT_VALUE
    this.updateOptions((value) => !this.isValueExist(value))
  }

  createOption(value) {
    const option = document.createElement('span')
    option.classList.add(
      'badge',
      'bg-base-300',
      'flex',
      'items-center',
      'gap-2'
    )
    option.textContent = value
    const remove = document.createElement('span')
    remove.classList.add(
      'cursor-pointer',
      'bg-base-300',
      'size-4',
      'flex',
      'items-center',
      'justify-center'
    )
    remove.dataset.value = value
    remove.dataset.action = 'click->multi-select#remove'
    remove.textContent = 'x'
    option.append(remove)
    return option
  }

  remove(event) {
    const value = event.target.dataset.value
    const index = this.selectedValues.indexOf(value)
    this.selectedValues.splice(index, 1)
    this.listTarget.children[index].remove()
    this.selectTarget.children[index].remove()
    this.updateOptions((value) => !this.isValueExist(value))
  }

  isValueExist(value) {
    return this.selectedValues.includes(value)
  }

  // hide option when predicate returns false
  updateOptions(predicate = () => true) {
    let hidden = true
    Array.from(this.optionsTarget.children).forEach((li) => {
      const value = li.children[0].textContent.trim()
      li.hidden = !predicate(value)
      hidden = hidden && li.hidden
    })
    this.menuTarget.hidden = hidden
  }

  filter(event) {
    const value = event.target.value.trim()
    this.updateOptions((option) =>
      option.toLowerCase().includes(value.toLowerCase())
    )
  }
}
