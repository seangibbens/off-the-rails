import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "label"]

  connect() {
    this.systemThemeChanged = this.systemThemeChanged.bind(this)
    this.media = window.matchMedia("(prefers-color-scheme: dark)")
    this.media.addEventListener("change", this.systemThemeChanged)
    this.apply(localStorage.getItem("theme") || this.systemTheme)
  }

  disconnect() {
    this.media.removeEventListener("change", this.systemThemeChanged)
  }

  toggle() {
    const theme = this.element.dataset.theme === "dark" ? "light" : "dark"
    localStorage.setItem("theme", theme)
    this.apply(theme)
  }

  systemThemeChanged() {
    if (!localStorage.getItem("theme")) this.apply(this.systemTheme)
  }

  get systemTheme() {
    return this.media.matches ? "dark" : "light"
  }

  apply(theme) {
    this.element.dataset.theme = theme
    this.buttonTarget.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} theme`)
    this.labelTarget.textContent = theme === "dark" ? "Light mode" : "Dark mode"
  }
}
