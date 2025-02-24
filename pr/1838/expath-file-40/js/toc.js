(function() {
  const updateDelta = function(target) {
    if (target.classList.contains("expanded")) {
      return;
    }

    let anchor = target;
    while (anchor && anchor.tagName !== "A") {
      anchor = anchor.previousSibling;
    }
    if (anchor && (anchor.querySelector("span.toc-chg")
                   || anchor.querySelector("span.toc-new"))) {
      return;
    }

    let delta = null;
    let details = target;
    while (details && details.tagName !== "DETAILS") {
      details = details.parentNode;
    }
    if (details) {
      delta = (details.querySelector("span.toc-chg")
               || details.querySelector("span.toc-new"))
    }

    // We're assuming innerHTML is a single text node...
    let inner = `${target.innerHTML}`;
    inner = inner.substring(inner.length - 1)
    if (delta) {
      inner = "Δ" + inner;
    }

    target.innerHTML = inner;
  }

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
      updateDelta(span);
    });
  }

  window.addEventListener("load", () => {
    document.querySelectorAll(".exptoc").forEach(span => {
      updateDelta(span)

      span.addEventListener("click", (event) => {
        let target = event.target;
        if (target.classList.contains("collapsed")) {
          target.classList.remove("collapsed");
          target.classList.add("expanded");
          target.innerHTML = `\u2009▼`;
        } else {
          target.classList.remove("expanded");
          target.classList.add("collapsed");
          target.innerHTML = `\u2009▶`;
        }
        updateDelta(target);
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
