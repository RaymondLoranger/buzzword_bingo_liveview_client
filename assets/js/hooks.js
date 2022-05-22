let Hooks = {} // containing object for any JS hooks...

Hooks.AutoFocus = {
  mounted() {
    this.el.focus()
  }
}

export default Hooks
