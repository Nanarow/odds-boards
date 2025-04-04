import Dropdown from '@stimulus-components/dropdown'

export default class extends Dropdown {
  static targets = ['list', 'input', 'select', 'option', 'options']
  static values = {
    default: Array,
    placeholder: String,
    options: Array,
  }
  DEFAULT_VALUE = ''
  DEFAULT_LABEL = 'Select'

  connect() {
    super.connect()
    this.selectedValues = []
    this.defaultValue.forEach((value) => {
      this.add(value)
    })
  }

  addByInput(event) {
    this.add(event.target.value)
  }

  addByOption(event) {
    this.add(event.target.textContent)
  }

  add(value) {
    console.log('value', value)
    value = value.trim()
    if (value && !this.isValueExist(value)) {
      this.selectedValues.push(value)
      this.selectTarget.append(new Option(value, value, false, true))
      this.listTarget.append(this.createOption(value))
    }
    this.inputTarget.value = this.DEFAULT_VALUE
    this.updateOptions()
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
    this.updateOptions()
  }

  isValueExist(value) {
    return this.selectedValues.includes(value)
  }

  updateOptions() {
    let hidden = true
    Array.from(this.optionsTarget.children).forEach((li) => {
      const value = li.children[0].textContent.trim()
      li.hidden = this.isValueExist(value)
      hidden = hidden && li.hidden
    })
    this.menuTarget.hidden = hidden
  }
}
