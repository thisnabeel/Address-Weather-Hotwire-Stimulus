// javascript/weather_controller.js
import { Controller } from "@hotwired/stimulus";

const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

export default class extends Controller {
  static targets = ["suggestions", "input", "forecast"];

  connect() {
    console.log("hello");
  }

  select(e) {
    this.inputTarget.value = e.target.innerHTML;
    this.suggestionsTarget.innerHTML = "";
    const forecastTarget = this.forecastTarget;

    const payload = {
      place_id: e.target.getAttribute("place_id"),
    };

    fetch("/weather/forecast", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => response.text())
      .then((data) => {
        forecastTarget.innerHTML = data;
      })
      .catch((error) => {
        console.error("Error fetching forecast:", error);
      });
  }

  searchInput() {
    const suggestionsTarget = this.suggestionsTarget;
    const inputTarget = this.inputTarget;

    const value = inputTarget.value;

    const payload = {
      address: value,
    };

    fetch("/address/suggestions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => response.text())
      .then((data) => {
        suggestionsTarget.innerHTML = data;
      })
      .catch((error) => {
        console.error("Error fetching suggestions:", error);
      });
  }
}
