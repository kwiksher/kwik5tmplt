import styles from "./Theming.modules.css"
import Toast from "./Toast"

const Theming = () => {
  return (
    <div className={styles.container}>
      <sp-body size="L" class={`${styles.body} ${styles.lightest}`}>This is the Lightest Theme</sp-body>
      <sp-body size="L" class={`${styles.body} ${styles.light}`}>This is the Light Theme</sp-body>
      <sp-body size="L" class={`${styles.body} ${styles.dark}`}>This is the Dark Theme</sp-body>
      <sp-body size="L" class={`${styles.body} ${styles.darkest}`}>This is the Darkest Theme</sp-body>   
      <Toast />
    </div>
  );
}

export default Theming;