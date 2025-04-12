import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input']
  submitInnerForm(event) {
    event.preventDefault()
    const form = event.target.closest('form')
    if (!form) return
    const clonedForm = form.cloneNode(true)
    document.body.appendChild(clonedForm)
    clonedForm.requestSubmit()
    clonedForm.remove()
  }

  reset() {
    this.inputTargets.forEach((input) => {
      input.value = ''
    })
  }
}
