window.onload = function() {
  let uri = window.location.toString();
  let pos = uri.indexOf("#pr-");
  if (pos > 0) {
    let pr = uri.substring(pos);
    let node = document.querySelector(pr);
    if (node == null) {
      uri = "https://github.com/qt4cg/qtspecs/pull/" + pr.substring(4);
      let body = document.querySelector("body");
      let main = document.querySelector("main");
      
      let div = document.createElement("div");
      div.setAttribute("class", "notice");
      div.style["background-color"] = "#ffcccc";
      div.style.border = "1px solid red";
      div.style.margin = "4em";
      div.style.padding = "2em";
      div.style["padding-top"] = "1em";
      div.style["padding-bottom"] = "1em";

      let inner = `<p>PR #${pr.substring(4)} is no longer on the dashboard. `;
      inner += "Redirecting to GitHub PR in…<span id='r_cd'>three</span></p>";

      div.innerHTML = inner;
      body.insertBefore(div, main);

      setTimeout(function() {
        document.querySelector("#r_cd").innerHTML = "two";
        setTimeout(function() {
          document.querySelector("#r_cd").innerHTML = "one";
          window.location = uri
        }, 1000);
      }, 1000);
    }
  }
}
