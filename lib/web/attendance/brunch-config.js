exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js",

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      order: {
        before: [
          "web/static/vendor/js/excanvas.min.js",
          "web/static/vendor/js/jquery.min.js",
          "web/static/vendor/js/jquery.ui.custom.js",
          "web/static/vendor/js/bootstrap.min.js",
          "web/static/vendor/js/matrix.dashboard.js",
          "web/static/vendor/js/jquery.peity.min.js",
          "web/static/vendor/js/fullcalendar.min.js",
          "web/static/vendor/js/matrix.js",
          "web/static/vendor/js/jquery.flot.min.js",
          "web/static/vendor/js/jquery.flot.resize.min.js",
          "web/static/vendor/js/matrix.dashboard.js",
          "web/static/vendor/js/jquery.gritter.min.js",
          "web/static/vendor/js/matrix.interface.js",
          "web/static/vendor/js/matrix.chat.js",
          "web/static/vendor/js/jquery.validate.js",
          "web/static/vendor/js/matrix.form_validation.js",
          "web/static/vendor/js/jquery.wizard.js",
          "web/static/vendor/js/jquery.uniform.js",
          "web/static/vendor/js/select2.min.js",
          "web/static/vendor/js/matrix.popover.js",
          "web/static/vendor/js/jquery.dataTables.min.js",
          "web/static/vendor/js/matrix.tables.js",
        ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        before: [
          "web/static/vendor/css/bootstrap.min.css",
          "web/static/vendor/css/bootstrap-responsive.min.css",
          "web/static/vendor/css/fullcalendar.css",
          "web/static/vendor/css/matrix-style.css",
          "web/static/vendor/css/matrix-media.css"
          ],
        after: ["web/static/css/app.css"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: [/^(web\/static\/assets)/,
      /^(web\/static\/assets\/css)/]
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
