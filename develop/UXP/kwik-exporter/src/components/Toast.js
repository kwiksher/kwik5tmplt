// import { useMediaQuery } from 'react-responsive' // will not work in UXP (yet?)
import lightest from "../img/lightest.png"
import light from "../img/light.png"
import dark from "../img/dark.png"
import darkest from "../img/darkest.png"
import styles from "./Theming.modules.css"

const Toast = () => {
  return (
    <>
      <img className={`${styles.toast} ${styles.lightest}`} src={lightest} width="50" />
      <img className={`${styles.toast} ${styles.light}`} src={light} width="50" />
      <img className={`${styles.toast} ${styles.dark}`} src={dark} width="50" />
      <img className={`${styles.toast} ${styles.darkest}`} src={darkest} width="50" />
    </>
  );
}

export default Toast;