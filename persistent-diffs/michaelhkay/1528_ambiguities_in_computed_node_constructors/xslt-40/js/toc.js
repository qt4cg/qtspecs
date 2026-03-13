(function() {
  const updateDelta = function(target) {
    let anchor = target;
    while (anchor && anchor.tagName !== "A") {
      anchor = anchor.previousSibling;
    }

    let added = false;
    let changed = false;
    let details = target;
    while (details && details.tagName !== "DETAILS") {
      details = details.parentNode;
    }
    if (details) {
      added = details.querySelector("span.toc-new");
      changed = details.querySelector("span.toc-chg");
    }

    if (target == null) {
      return;
    }

    // We're assuming innerHTML is a single text node...
    let inner = "";
    if (added) {
      if (changed) {
        inner = "&#xa0;<span style='font-size: 120%'>\u202F✚✭</span>";
      } else {
        inner = "&#xa0;<span style='font-size: 120%'>\u202F✚</span>";
      }
    } else if (changed) {
      inner = "&#xa0;<span style='font-size: 120%'>\u202F✭</span>";
    }
    target.innerHTML = inner;
  }

  const fold = function(open, target) {
    target.classList.remove(open ? "collapsed" : "expanded");
    target.classList.add(open ? "expanded" : "collapsed");
    target.innerHTML = "";
  };

  const updateToc = function(open) {
    document.querySelectorAll(".toc details").forEach(details => {
      details.open = open;
    });
    document.querySelectorAll(".exptoc").forEach(span => {
      fold(open, span);
      updateDelta(span);
    });
  };

  window.addEventListener("load", () => {
    document.querySelectorAll(".exptoc").forEach(span => {
      updateDelta(span)
    });

    document.querySelectorAll("details summary a span.content").forEach(span => {
      if (span.classList.contains("toc-new") || span.classList.contains("toc-chg")) {
        let anchor = span.parentNode
        if (!anchor.nextSibling) {
          if (span.classList.contains("toc-new")) {
            span.innerHTML = span.innerHTML + "\u202F✚";
          }
          if (span.classList.contains("toc-chg")) {
            span.innerHTML = span.innerHTML + "\u202F✭";
          }
        }
      }
    });

    document.querySelectorAll(".toc details summary").forEach(summary => {
      summary.addEventListener("click", (event) => {
        event.stopPropagation();
        let target = event.target
        while (target && target.tagName != "DETAILS") {
          target = target.parentNode;
        }

        let details = target
        details.open = !details.open;

        target = target.querySelector(".exptoc")
        if (target != null) {
          if (target.classList.contains("collapsed")) {
            target.classList.remove("collapsed");
            target.classList.add("expanded");
          } else {
            target.classList.remove("expanded");
            target.classList.add("collapsed");
          }
          updateDelta(target);
        }
      });
    });

    let expandAll = document.querySelector(".expalltoc")
    if (expandAll) {
      expandAll.addEventListener("click", (event) => {
        event.stopPropagation();

        let target = event.target;
        if (target.classList.contains("collapsed")) {
          target.classList.remove("collapsed")
          target.classList.add("expanded")
          target.innerHTML = `\u2009▼`;
          updateToc(true)
        } else {
          target.classList.remove("expanded")
          target.classList.add("collapsed")
          target.innerHTML = `\u2009▶`;
          updateToc(false)
        }
      });
    }
  });
})();
