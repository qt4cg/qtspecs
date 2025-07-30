(function() {
  window.addEventListener("load", () => {
    const help = document.querySelector("#help-select-fn");

    const gotoFunction = function(name) {
      if (name.slice(-1) === '\u2063') {
        name = name.slice(0, -1);
      }
      let pos = name.indexOf(":");
      let prefix = name.substring(0, pos);
      let local = name.substring(pos+1);

      help.style.display = "none";
      if (prefix === "fn" || prefix === "op") {
        window.location = "#func-" + local;
      } else {
        window.location = "#func-" + prefix + "-" + local;
      }
    }

    document.querySelector("#help-select-fn-button").addEventListener("click", function(event) {
      if (help.style.display === "block") {
        help.style.display = "none";
      } else {
        help.style.display = "block";
      }
    });

    document.querySelector('#select-fn').addEventListener('input', function(event) {
      if (this.value.slice(-1) === '\u2063') {
        let name = this.value;
        this.value = "";
        gotoFunction(name);
      }
    });

    document.querySelector("html").addEventListener('keydown', function(event) {
      let inputField = document.querySelector("#select-fn");
      let focused = document.activeElement;
      if (inputField === focused) {
        if (event.key === "Enter" && inputField.value.length > 0) {
          let match = null;
          for (let item of document.querySelectorAll("#fn-list option")) {
            if (item.value.indexOf(inputField.value) >= 0) {
              if (match == null) {
                match = item.value;
              } else{
                return;
              }
            }
          }
          if (match != null) {
            inputField.value = "";
            gotoFunction(match);
          }
        }
      } else {
        if (event.key === "/") {
          event.stopPropagation();
          event.preventDefault();
          inputField.focus();
        }
      }
    });
  });
})();
