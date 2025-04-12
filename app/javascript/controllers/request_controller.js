import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  submit(event) {
    const form = document.createElement('form')
    form.method = 'post'
    form.action = event.target.dataset.formAction
    form.acceptCharset = 'UTF-8'

    form.appendChild(
      this.createInput('authenticity_token', event.target.dataset.token)
    )

    Object.entries(JSON.parse(event.target.dataset.formData)).forEach(
      ([key, value]) => form.appendChild(this.createInput(key, value))
    )

    document.body.appendChild(form)
    form.requestSubmit()
    form.remove()
  }

  createInput(name, value) {
    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = name
    input.value = value
    return input
  }
}
