import "./style.css";
import { Elm } from "./src/Main.elm";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer");

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const root = document.querySelector("#app div");
const r = localStorage.getItem("auth");
(async () => {
  const user = async (token) => {
    if (token === "") return null;
    const f = await fetch("http://localhost:3000/is_auth", {
      method: "GET",
      headers: { auth: token },
    });
    const r = await f.json();
    if (r.login && r.user) {
      console.log(JSON.parse(r.user));
      return JSON.parse(r.user);
    }
    return null;
  };
  const app = Elm.Main.init({
    node: root,
    flags: { token: r ? r : "", user: await user(r) },
  });
  app.ports.setStorage.subscribe(function(state) {
    localStorage.setItem("auth", state);
  });

  app.ports.removeItem.subscribe(function() {
    localStorage.removeItem("auth");
  });
})();
