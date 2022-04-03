import photoshop from "photoshop"

const alert = (s) => { return photoshop.app.showAlert(s) }

const showAbout = () => {
  alert("Thanks for trying this UXP plugin!")
}

const doAction = async (actionSet, action) => {
  await photoshop.app.actionTree
    .find(({name}) => name === actionSet)
    .actions
    .find(({name}) => name === action)
    .play()
}

// named export: it allows for other stuff to be added later on
export { doAction, alert, showAbout }