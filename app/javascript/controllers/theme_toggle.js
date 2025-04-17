import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'light', 'dark']
  connect() {
    this.prefersDark = window.matchMedia('(prefers-color-scheme: dark)')
    this.applyTheme(this.prefersDark.matches)
    this.prefersDark.addEventListener('change', this.onChange.bind(this))
  }

  disconnect() {
    this.prefersDark.removeEventListener('change', this.onChange.bind(this))
  }

  onChange(event) {
    this.applyTheme(event.matches)
  }

  applyTheme(isDark) {
    this.inputTarget.value = isDark ? 'light' : 'dark'
    this.lightTarget.classList.toggle('swap-on', !isDark)
    this.lightTarget.classList.toggle('swap-off', isDark)
    this.darkTarget.classList.toggle('swap-on', isDark)
    this.darkTarget.classList.toggle('swap-off', !isDark)
  }
}
