import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap"


export default class extends Controller {
  connect() {
    console.log("connteced popup controller.........")
    this.modal = new Modal(this.element)
  }
  closeEvent(event) {
      this.modal.hide()
  }
}
