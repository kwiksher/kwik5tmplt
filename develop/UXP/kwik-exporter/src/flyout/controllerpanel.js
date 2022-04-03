import { showAbout } from "../photoshop/scripts"
import { entrypoints } from "uxp";

export default {
  menuItems: [
    {
      id: "preferences", label: "Preferences", submenu:
        [
          { id: "tooltips", label: "Show tooltips", checked: true },
          { id: "updates", label: "Check for updates" },
          {
            id: "advancedmenu", label: "Advanced features", enabled: true, submenu:
              [
                { id: "savelogs", label: "Collect debugging info", enabled: false, checked: true },
                { id: "sendlogs", label: "Upload debugging info", enabled: false },
              ]
          },
          { id: "spacer", label: "-" }, // SPACER
          { id: "toggleadvanced", label: "🚥 Enable advanced features" },
        ]
    },
    { id: "about", label: "About" },
  ],
  invokeMenu(id) {
    console.log("Clicked menu with id", id);
    const { menuItems } = entrypoints.getPanel("controllerpanel");
    switch (id) {
      case "about":
        showAbout();
        break;
      case "tooltips":
        menuItems.getItem("tooltips").checked = !menuItems.getItem("tooltips").checked;
        // do whatever else you need after 
        break;
      case "toggleadvanced":
        menuItems.getItem("savelogs").enabled = !menuItems.getItem("savelogs").enabled;
        menuItems.getItem("sendlogs").enabled = !menuItems.getItem("sendlogs").enabled;
        let l = menuItems.getItem(id).label;
        menuItems.getItem(id).label = l.indexOf("Enable") > -1 ?
          l.replace("Enable", "Disable") :
          l.replace("Disable", "Enable");
        break;
      default: console.log("Nothing to do here...")
    }
  }
}