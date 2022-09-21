window.onload = function() {
  SaxonJS.transform({
    stylesheetLocation: "stylesheet.sef.json?date=2022-09-21",
    initialTemplate: "Q{}main"
  }, "async");
};
