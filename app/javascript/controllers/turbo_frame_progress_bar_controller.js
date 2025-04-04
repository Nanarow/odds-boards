import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['progress']
  static values = {
    transitionDuration: { type: Number, default: 500 },
  }

  start(event) {
    const isPrefetch =
      event.detail.fetchOptions?.headers?.['X-Sec-Purpose'] === 'prefetch'

    if (isPrefetch) return
    if (!this.hasProgressTarget) return

    this.progressTarget.style.transition = 'none'
    this.progressTarget.style.width = '0%'

    requestAnimationFrame(() => {
      this.progressTarget.style.transition = `width ${this.transitionDurationValue}ms ease`
      this.progressTarget.style.width = '40%'
    })
  }

  finish() {
    if (!this.hasProgressTarget) return

    this.progressTarget.style.width = '100%'

    setTimeout(() => {
      this.progressTarget.style.transition = 'none'
      this.progressTarget.style.width = '0%'
    }, this.transitionDurationValue)
  }
}
