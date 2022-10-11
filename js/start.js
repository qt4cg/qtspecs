window.onload = function() {
  document.querySelector("html").className = "js";

  // Work out the protocol and hostname of our source...
  let location = window.location.href;
  let webroot = "";
  let pos = location.indexOf("//");
  webroot = location.substring(0, pos+2);
  location = location.substring(pos+2);
  pos = location.indexOf("/");
  if (pos > 0) {
    webroot += location.substring(0, pos);
  } else {
    webroot += location;
  }

  const configJson = `${webroot}/dashboard.json?date=2022-10-11-1`;
  SaxonJS.getResource({"location": configJson,
                       "type": "json"})
    .then(config => {
      SaxonJS.transform({
        "stylesheetLocation": "dashboard.sef.json?date=2022-10-11-1",
        "initialTemplate": "Q{}main",
        "stylesheetParams": {
          "Q{}config": config
        }
      }, "async");
    })
    .catch(err => {
      // There's a fair bit of config here where we could in principle
      // get the information from the GitHub API. Unfortunately, that
      // API is rate limited and for non-logged-in users, it's easy to
      // go over the limit. (Perhaps someday I'll make a version that
      // you can login with for a higher limit. But really, this
      // configuration doesn't change very often.
      console.log(`Failed to load ${configJson}; using defaults`);
      const config = {
        "web-root": webroot,
        "main-branch-name": "master",
        "main-branch-prefix": "/specifications",
        "branch-prefix": "/branch",
        "branch-suffix": "",
        "pr-path": "/pr",
        "branches": {
          "qt4cg": {
            "qtspecs": {
              "master": "The latest drafts",
              "gh-pages": "#IGNORE",
              "xslt-erratum-e30": "#IGNORE",
              "v4": "#IGNORE",
              "fn-all-some": "#IGNORE"
            }
          }
        },
        "ignore": {
          "qt4cg": {
            "qtspecs": {
              "pulls": [27, 28, 48]
            }
          }
        },
        "documents": {
          "qt4cg": {
            "qtspecs": ["xpath-functions-40", "xquery-40", "xslt-40"]
          }
        },
        "indexes": {
          "qt4cg": {
            "qtspecs": {
              "xpath-functions-40": {
                "Overview.html": "XPath and XQuery Functions and Operators 4.0"
              },
              "xquery-40": {
                "xpath-40.html": "XML Path Language (XPath) 4.0",
                "xquery-40.html": "XQuery 4.0: An XML Query Language",
                //"shared-40.html": "XQuery 4.0 and XPath 4.0"
              },
              "xslt-40": {
                "index.html": "XSL Transformations (XSLT) Version 4.0"
              }
            }
          }
        }
      };
      SaxonJS.transform({
        "stylesheetLocation": "dashboard.sef.json?date=2022-09-24-4",
        "initialTemplate": "Q{}main",
        "stylesheetParams": {
          "Q{}config": config
        }
      }, "async");
    });

  const descriptions = {};
  window.renderCommonMark = function(id, md) {
    const reader = new commonmark.Parser();
    const writer = new commonmark.HtmlRenderer();
    const parsed = reader.parse(md);
    const result = writer.render(parsed);
    descriptions[id] = result;
  };

  window.insertMarkdown = function() {
    Object.keys(descriptions).forEach(key => {
      const div = document.querySelector(`#${key}`);
      if (div != null) {
        div.innerHTML = descriptions[key];
      }
    });
  };
};
