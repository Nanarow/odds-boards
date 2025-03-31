import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['content']
  static values = {
    open: { type: Boolean, default: false },
  }

  connect() {
    this.updateState()
    this.handleTransitionEnd = this.handleTransitionEnd.bind(this)
    this.contentTarget.addEventListener('transitionend', this.handleTransitionEnd)
  }

  disconnect() {
    this.contentTarget.removeEventListener('transitionend', this.handleTransitionEnd)
  }

  toggle(event) {
    event.preventDefault()
    this.openValue = !this.openValue
  }

  openValueChanged() {
    this.updateState()
  }

  updateState() {
    if (this.openValue) {
      this.contentTarget.classList.remove('hidden')
      this.contentTarget.style.maxHeight = `${this.contentTarget.scrollHeight}px`
    } else {
      this.contentTarget.style.maxHeight = '0'
    }
  }

  handleTransitionEnd(event) {
    if (event.propertyName === 'max-height' && !this.openValue) {
      this.contentTarget.classList.add('hidden')
    }
  }
}