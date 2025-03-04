(function() {
  const updateToc = function(open) {
    document.querySelectorAll(".toc details").forEach(details => {
      details.open = open
    });
    document.querySelectorAll(".exptoc").forEach(span => {
      if (open) {
        span.classList.remove("collapsed")
        span.classList.add("expanded")
        span.innerHTML = "\u2009▼"
      } else {
        span.classList.remove("expanded")
        span.classList.add("collapsed")
        span.innerHTML = "\u2009▶"
      }
    });
  }

  window.addEventListener("load", () => {
    document.querySelectorAll(".exptoc").forEach(span => {
      span.addEventListener("click", (event) => {
        let target = event.target;
        if (target.classList.contains("collapsed")) {
          target.classList.remove("collapsed")
          target.classList.add("expanded")
          target.innerHTML = "\u2009▼"
        } else {
          target.classList.remove("expanded")
          target.classList.add("collapsed")
          target.innerHTML = "\u2009▶"
        }
      });
    });

    let expandAll = document.querySelector(".expalltoc")
    if (expandAll) {
      expandAll.addEventListener("click", (event) => {
        let target = event.target;
        if (target.classList.contains("collapsed")) {
          target.classList.remove("collapsed")
          target.classList.add("expanded")
          target.innerHTML = "\u2009▼"
          updateToc(true)
        } else {
          target.classList.remove("expanded")
          target.classList.add("collapsed")
          target.innerHTML = "\u2009▶"
          updateToc(false)
        }
      });
    }
  });
})();
