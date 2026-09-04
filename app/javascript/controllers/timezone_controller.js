import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "sun", "moon"]

  connect() {
    this.update()
    this.refreshTimer = window.setInterval(() => this.update(), 60_000)
  }

  disconnect() {
    window.clearInterval(this.refreshTimer)
  }

  update() {
    const now = new Date()
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone
    const timeZoneName = new Intl.DateTimeFormat(undefined, { timeZoneName: "short" })
      .formatToParts(now)
      .find(({ type }) => type === "timeZoneName")?.value || timeZone
    const isDaytime = now.getHours() >= 6 && now.getHours() < 18

    this.labelTarget.textContent = timeZoneName
    this.sunTarget.hidden = !isDaytime
    this.moonTarget.hidden = isDaytime
    this.element.title = timeZone
    this.element.setAttribute("aria-label", `Your timezone: ${timeZone}. It is ${isDaytime ? "daytime" : "nighttime"}.`)
  }
}
