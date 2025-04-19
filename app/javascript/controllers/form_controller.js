import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  submitInnerForm(event) {
    event.preventDefault()
    const form = event.target.closest('form')
    if (!form) return
    const clonedForm = form.cloneNode(true)
    document.body.appendChild(clonedForm)
    clonedForm.requestSubmit()
    clonedForm.remove()
  }

  debounceSubmit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }

  submit() {
    this.element.requestSubmit()
  }
}
