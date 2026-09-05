import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "celebration", "display", "form", "level", "resultKicker", "resultMessage",
    "resultNumbers", "resultPanel", "selector", "status", "submit", "wheel"
  ]
  static values = { maxNumber: Number, played: Boolean }

  disconnect() {
    clearInterval(this.numberTimer)
    clearTimeout(this.resultTimer)
  }

  decrement() {
    this.selectorTarget.selectedIndex = Math.max(0, this.selectorTarget.selectedIndex - 1)
    this.choose()
  }

  increment() {
    this.selectorTarget.selectedIndex = Math.min(this.selectorTarget.options.length - 1, this.selectorTarget.selectedIndex + 1)
    this.choose()
  }

  choose() {
    this.statusTarget.textContent = `Number ${this.selectorTarget.value} selected. Ready to spin.`
  }

  async spin(event) {
    event.preventDefault()
    if (this.playedValue) return

    const formData = new FormData(this.formTarget)
    this.playedValue = true
    this.setControlsDisabled(true)
    this.statusTarget.textContent = "The wheel is spinning..."
    this.element.classList.add("lotto--spinning")

    try {
      const response = await fetch(this.formTarget.action, {
        method: "POST",
        body: formData,
        headers: {
          Accept: "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
        }
      })
      const data = await response.json()

      if (!response.ok) throw new Error(data.error || "The wheel could not spin.")
      if (data.created) {
        this.animateResult(data)
      } else {
        this.revealResult(data)
      }
    } catch (error) {
      this.playedValue = false
      this.setControlsDisabled(false)
      this.element.classList.remove("lotto--spinning")
      this.statusTarget.textContent = error.message
    }
  }

  animateResult(data) {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.revealResult(data)
      return
    }

    const spinCount = 6
    const segmentAngle = 360 / data.play.max_number
    const landingAngle = 360 - ((data.play.drawn_number - 1) * segmentAngle)

    this.numberTimer = setInterval(() => {
      this.displayTarget.textContent = Math.floor(Math.random() * data.play.max_number) + 1
    }, 70)
    this.wheelTarget.style.setProperty("--wheel-rotation", `${spinCount * 360 + landingAngle}deg`)
    this.resultTimer = setTimeout(() => this.revealResult(data), 3800)
  }

  revealResult(data) {
    clearInterval(this.numberTimer)
    clearTimeout(this.resultTimer)
    this.displayTarget.textContent = data.play.drawn_number
    this.levelTarget.textContent = data.current_max_number
    this.element.classList.remove("lotto--spinning")
    this.element.classList.add("lotto--complete")
    this.resultPanelTarget.hidden = false
    this.resultPanelTarget.classList.toggle("lotto-result--win", data.play.won)
    this.resultPanelTarget.classList.toggle("lotto-result--loss", !data.play.won)
    this.resultKickerTarget.textContent = data.play.won ? "Winner!" : "Not this time"
    this.resultNumbersTarget.innerHTML = `You picked <strong>${data.play.chosen_number}</strong>. The wheel found <strong>${data.play.drawn_number}</strong>.`
    this.resultMessageTarget.textContent = data.play.won
      ? `Level ${data.current_max_number} is waiting for you tomorrow.`
      : `Your level holds at ${data.current_max_number}. Try again tomorrow.`
    this.statusTarget.textContent = data.play.won ? "You won today's Lotto draw!" : "Today's spin is complete."
    this.submitTarget.value = "Played today"

    if (data.play.won) this.celebrate()
  }

  celebrate() {
    this.celebrationTarget.hidden = false
    this.element.classList.add("lotto--winner")
  }

  setControlsDisabled(disabled) {
    this.selectorTarget.disabled = disabled
    this.submitTarget.disabled = disabled
    this.formTarget.querySelectorAll("button").forEach((button) => { button.disabled = disabled })
  }
}
