window.onload = function() {
  SaxonJS.transform({
    stylesheetLocation: "stylesheet.sef.json",
    sourceLocation: "index.xml"
  }, "async");
};
