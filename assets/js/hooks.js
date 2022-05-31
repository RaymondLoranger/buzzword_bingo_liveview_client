let Hooks = {} // containing object for any JS hooks...

Hooks.AutoFocus = {
  mounted() {
    this.el.focus()
  }
}

Hooks.ScrollToEnd = {
  updated() {
    this.el.scrollTop = this.el.scrollHeight
  }
}

export default Hooks
