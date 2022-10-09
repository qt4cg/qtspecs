class DXmlView {
  constructor() {
    this.body = document.querySelector("body");

    this.old_classes = ["deltaxml-old", "deltaxml-old-img", "deltaxml-old-format"];
    this.new_classes = ["deltaxml-new", "deltaxml-new-img", "deltaxml-new-format"];
    this.del_classes = ["delete_version"];
    this.add_classes = ["add_version"];
    this.mod_classes = ["modify_version"];

    // Turn the classes into selector patterns
    let patterns = [];
    this.old_classes.forEach(name => { patterns.push("."+name); });
    this.new_classes.forEach(name => { patterns.push("."+name); });
    this.del_classes.forEach(name => { patterns.push("."+name); });
    this.add_classes.forEach(name => { patterns.push("."+name); });
    this.mod_classes.forEach(name => { patterns.push("."+name); });

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
    document.querySelectorAll(patterns.join(",")).forEach(item => {
      this.all_diff.push(item);
      if (!this.toc_diff.includes(item)) {
        this.xml_diff.push(item);
      }
    });

    this.visible_diff = [];
    this.visible_offset = [];
    this.recalculate = true;

    this.fadingMessage(`  (${this.xml_diff.length.toLocaleString()} differences)`);
  }

  fadingMessage(message) {
    let span = document.querySelector("#__autodiff__");
    if (span) {
      span.innerHTML = message;
      span.className = "autoshow";

      setTimeout(function(){
        span.className = "autohide";
        setTimeout(function(){
          span.innerHTML = "";
          span.className = "";
        }, 5000);
      }, 100);
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
    this.all_diff.forEach(span => {
      let displayType= this.displayType(span);
      if (this.new_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background = "#90EE90";
        //need to add border to images
        span.querySelectorAll("img").forEach(img => {
          img.style.border = "2px solid green";
        });
      } else if (this.old_classes.includes(span.className)) {
        span.style.display = displayType;
        span.style.background = "#FF5555";
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
  } else {
    console.log("Unexpected view doc: ", doc);
  }
};
