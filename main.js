import "./style.css";
import { Elm } from "./src/Main.elm";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer")

  ElmDebugTransform.register({
    simple_mode: true
  })
}

const root = document.querySelector("#app div");
const r = localStorage.getItem('auth');
const app = Elm.Main.init({ node: root, flags: r ? r : "" });
app.ports.setStorage.subscribe(function(state) {
  localStorage.setItem('auth', state);
});
