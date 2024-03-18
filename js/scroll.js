const DELETED = "rgb(255, 85, 85, 0.3)";
const ADDED = "rgb(144, 238, 144, 0.3)";

class DXmlView {
  constructor() {
    this.body = document.querySelector("body");

    this.old_classes = ["deltaxml-old", "deltaxml-old-img", "deltaxml-old-format"];
    this.new_classes = ["deltaxml-new", "deltaxml-new-img", "deltaxml-new-format"];
    this.del_classes = ["delete_version"];
    this.add_classes = ["add_version"];
    this.mod_classes = ["modify_version"];

    this.all_classes = [];
    this.old_classes.forEach(name => { this.all_classes.push(name); });
    this.new_classes.forEach(name => { this.all_classes.push(name); });
    this.del_classes.forEach(name => { this.all_classes.push(name); });
    this.add_classes.forEach(name => { this.all_classes.push(name); });
    this.mod_classes.forEach(name => { this.all_classes.push(name); });

    // Turn the classes into selector patterns
    let patterns = [];
    this.all_classes.forEach(name => { patterns.push("."+name); });

    this.all_selector = patterns.join(",");

    // Select any element in the ToC; we want to exclude these
    // because they're in a separate scroll and that messes with
    // with the next/previous functionality
    let tocSelector = "";
    patterns.forEach(pattern => {
      if (tocSelector !== "") {
        tocSelector += ",";
      }
      tocSelector += "#toc " + pattern;
    });

    this.toc_diff = [];
    document.querySelectorAll(tocSelector).forEach(item => {
      this.toc_diff.push(item);
    });

    this.all_diff = [];
    this.xml_diff = [];
    document.querySelectorAll(this.all_selector).forEach(item => {
      this.all_diff.push(item);
      if (!this.toc_diff.includes(item)) {
        this.xml_diff.push(item);
      }
    });

    this.visible_diff = [];
    this.visible_offset = [];
    this.recalculate = true;
    this.fading = false;
    this.stylemap = new Map();

    this.fadingMessage(`  (${this.xml_diff.length.toLocaleString()} differences)`);
  }

  fadingMessage(message) {
    let span = document.querySelector("#__autodiff__");
    if (span) {
      span.innerHTML = message;
      span.className = "autoshow";

      if (!this.fading) {
        this.fading = true;
        let outer = this;
        setTimeout(function(){
          span.className = "autohide";
          setTimeout(function(){
            span.innerHTML = "";
            span.className = "";
            outer.fading = false;
          }, 5000);
        }, 100);
      }
    }
  }
  
  absoluteTop(item) {
    let top = item.offsetTop;
    while (item && item.offsetParent !== this.body) {
      item = item.offsetParent;
      if (item === null) {
        return -1;
      }
      top += item.offsetTop;
    }
    return top;
  }

  find_visible_diffs() {
    this.visible_diff = [];
    this.visible_offset = [];
    this.xml_diff.forEach(item => {
      let ofs = this.absoluteTop(item);
      if (ofs >= 0) {
        this.visible_diff.push(item);
        this.visible_offset.push(ofs);
      }
    });
    this.recalculate = false;
    window.DIFF = this.visible_diff;
  }

  scroll_forward() {
    if (this.recalculate) {
      this.find_visible_diffs();
    }

    let topY = window.scrollY;
    let bottomY = window.scrollY + window.innerHeight - 1;
    let halfY = (bottomY - topY) / 2;

    let curOffset = 0;
    let cur_diff = 0;
    while (cur_diff < this.visible_offset.length
           && this.visible_offset[cur_diff] < topY) {
      cur_diff++;
      curOffset = this.visible_offset[cur_diff];
    }

    while (curOffset < bottomY && cur_diff < this.visible_diff.length) {
      cur_diff++;
      curOffset = this.visible_offset[cur_diff];
    }

    if (cur_diff < this.visible_diff.length) {
      window.scrollTo(0, curOffset - halfY);
      this.fadingMessage(`Difference ${cur_diff.toLocaleString()} of ${this.xml_diff.length.toLocaleString()}.`);
    } else {
      this.fadingMessage("There are no more following differences.");
    }
  }

  scroll_backward() {
    if (this.recalculate) {
      this.find_visible_diffs();
    }

    let topY = window.scrollY;
    let bottomY = window.scrollY + window.innerHeight - 1;
    let halfY = (bottomY - topY) / 2;

    let curOffset = 0;
    let cur_diff = 0;
    while (cur_diff < this.visible_offset.length
           && this.visible_offset[cur_diff] < topY) {
      cur_diff++;
      curOffset = this.visible_offset[cur_diff];
    }

    if (cur_diff > 0) {
      cur_diff--;
      curOffset = this.visible_offset[cur_diff];
      if (cur_diff < this.visible_diff.length) {
        window.scrollTo(0, curOffset - halfY);
        this.fadingMessage(`Difference ${cur_diff.toLocaleString()} of ${this.xml_diff.length.toLocaleString()}.`);
      }
    } else {
      this.fadingMessage("The are no more preceding differences.");
    }
  }

  displayType(span) {
    if (span.localName === "tr") {
      return "table-row";
    }

    if (span.localName === "li") {
      return "list-item";
    }
    
    return "inline";
  }

  view_old() {
    this.restore_view();
    this.all_diff.forEach(span => {
      let displayType = this.displayType(span);
      if (this.old_classes.includes(span.className) || this.del_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background="#FFF";
        //need to take border off images
        span.querySelectorAll("img").forEach(img => {
          img.style.border = "none";
        });
      } else {
        span.style.display = "none";
      }
    });
  }

  view_new() {
    this.restore_view();
    this.all_diff.forEach(span => {
      let displayType = this.displayType(span);
      if (this.new_classes.includes(span.className) || this.add_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background = "#FFF";
        //need to take border off images
        span.querySelectorAll("img").forEach(img => {
          img.style.border = "none";
        });
      } else {
        span.style.display = "none";
      }
    });
  }

  view_both() {
    this.restore_view();
    this.all_diff.forEach(span => {
      let displayType= this.displayType(span);
      if (this.new_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background = ADDED
        //need to add border to images
        span.querySelectorAll("img").forEach(img => {
          img.style.border = "2px solid green";
        });
      } else if (this.old_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background = DELETED;
        //need to add border to images
        span.querySelectorAll("img").forEach(img => {
          img.style.border = "2px solid red";
        });
      } else if (this.add_classes.includes(span.className)
                 || this.del_classes.includes(span.className)) {
        span.style.display = "none";
      } else {
        span.style.display= displayType;
      }
    });
  }

  view_only() {
    this.restore_view();
    this.recursediffs(document.querySelector("body"));
    let buttons = document.querySelector("#_autodiff_buttons");
    if (buttons) {
      buttons.style.display = "block";
    }
    this.recalculate = true;
  }

  restore_view() {
    if (this.stylemap.size === 0) {
      return;
    }

    const nodeIter = this.stylemap.entries();
    let item = nodeIter.next();
    while (!item.done) {
      const node = item.value[0];
      for (const [key, value] of Object.entries(item.value[1])) {
        if (node.style) {
          node.style[key] = value;
        } else {
          node.style.display = value;
        }
      }
      item = nodeIter.next();
    }

    this.stylemap.clear();
    this.recalculate = true;
  }
   
  recursediffs(root) {
    for (const child of root.children) {
      this.stylemap.set(child, {'display': child.style.display});

      // Don't bother computing the intersection if child.classList is empty
      let intersect = [];
      if (child.classList.length > 0) {
        intersect = this.all_classes.filter(name => child.classList.contains(name));
      }
      
      if (intersect.length > 0) {
        this.find_header(child);
      } else {
        if (child.querySelector(this.all_selector)) {
          this.recursediffs(child);
        } else {
          child.style.display = "none";
          }
      }
    }
  }

  find_header(node) {
    if (["H1", "H2", "H3", "H4", "H5", "H6"].includes(node.nodeName)) {
      let props = this.stylemap.get(node);
      node.style.display = props["display"];
      if (!("border-top" in props)) {
        props["border-top"] = node.style["border-top"];
        props["margin-top"] = node.style["margin-top"];
        props["padding-top"] = node.style["padding-top"];
      }
      node.style["border-top"] = "6px dotted " + DELETED;
      node.style["padding-top"] = "20px";
      node.style["margin-top"] = "20px";
      return;
    }

    if (node.nodeName == "BODY") {
      return;
    }

    while (node.previousSibling) {
      node = node.previousSibling;
      if ("style" in node) {
        let props = this.stylemap.get(node);
        node.style.display = props["display"];
      }
      if (["H1", "H2", "H3", "H4", "H5", "H6"].includes(node.nodeName)) {
        let props = this.stylemap.get(node);
        node.style.display = props["display"];
        if (!("border-top" in props)) {
          props["border-top"] = node.style["border-top"];
          props["margin-top"] = node.style["margin-top"];
          props["padding-top"] = node.style["padding-top"];
        }
        node.style["border-top"] = "6px dotted " + DELETED;
        node.style["padding-top"] = "20px";
        node.style["margin-top"] = "20px";
        return;
      }
    }
    node = node.parentNode;
    if (node) {
      this.find_header(node);
    }
  }

  mark_change(node, className, color, changebarColor) {
    node.classList.add(className);
    node.style["background-color"] = color;
    if (className == "deltaxml-old") {
      node.style["text-decoration-line"] = "line-through";
      node.style["text-decoration-color"] = "#555555";
    }

    for (const child of node.children) {
      child.classList.remove(className);
      child.style["background-color"] = "transparent"
      if (child.nodeName == "DIV" || child.nodeName == "P" || child.nodeName == "LI"
        ||  child.nodeName == "DT" || child.nodeName == "DD") {
          child.style["border-right"] = "none";
          if (className == "deltaxml-old") {
            node.style["text-decoration"] = "none";
          }
        }
    }

    if (node.nodeName == "DIV" || node.nodeName == "P" || node.nodeName == "LI"
      || node.nodeName == "DT" || node.nodeName == "DD") {
        node.style["border-right"] = "6px solid " + changebarColor;
      }
  }

  tidy_change_markup(node, depth) {
    //console.log(`WALK: ${node.nodeName} ${depth}`);

    let status = node.classList.contains("deltaxml-new") ? "new"
      : (node.classList.contains("deltaxml-old") ? "old" : "undecided")

    if (status == "undecided") {
      for (const child of node.children) {
        this.tidy_change_markup(child, depth+1)
      }

      let markOld = true
      let markNew = true
      for (const child of node.children) {
        markOld = markOld && (child.childNodes.length == 0 || child.classList.contains("deltaxml-old"))
        markNew = markNew && (child.childNodes.length == 0 || child.classList.contains("deltaxml-new"))
        //console.log(`  ?? ${node.nodeName}: ${markOld}/${markNew}`)
      }

      if (markOld && markNew) {
        status = "undecided";
      } else if (markOld) {
        status = "old";
      } else if (markNew) {
        status = "new";
      } else {
        status = "mixed";
      }
    }

    if (status == "new") {
      this.mark_change(node, "deltaxml-new", ADDED, "green")
    } else if (status == "old") {
      this.mark_change(node, "deltaxml-old", DELETED, "red")
    }
  }
}

// I'm not sure this is the cleanest approach...

let dxmlview = new DXmlView();
window.scroll_to = function(direction) {
  if (direction == 'next') {
    dxmlview.scroll_forward();
  } else if (direction === 'prev') {
    dxmlview.scroll_backward();
  } else {
    console.log("Unexpected scroll direction: ", direction);
  }
};

window.view = function(doc) {
  if (doc === "new") {
    dxmlview.view_new();
  } else if (doc === "old") {
    dxmlview.view_old();
  } else if (doc === "both") {
    dxmlview.view_both();
  } else if (doc === "only") {
    dxmlview.view_both();
    dxmlview.view_only();
  } else {
    console.log("Unexpected view doc: ", doc);
  }
};

window.addEventListener('resize', (event) => {
  dxmlview.find_visible_diffs();
});

dxmlview.view_both();
dxmlview.tidy_change_markup(document.querySelector("body"), 0)
