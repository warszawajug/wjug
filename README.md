# Crash-course jak to odpalić

* Wejdź na http://nodejs.org/ i ściągnij nodejs, rozpakuj, uruchom

  ./configure

  make

  sudo make install

* teraz zainstaluj markdowna

  npm install marked --save

* wróć do katalogu projektu i odpal

  ./scripts/init.sh

to ściągnie wszystkie zależności strony

* wróć do katalogu projektu i odpal

  ./scripts/server.sh

to odpali generowanie strony i wystawi ją na localhost:3333


### Jak dodać link do relacji ze spotkania?

Bardzo łatwo ;p, przykładowy commit: [7edcf87aba4d7733f3c3f2362c0239ce28d37326](https://github.com/jakubnabrdalik/wjug/commit/7edcf87aba4d7733f3c3f2362c0239ce28d37326)

### Jak deployować?

* musisz mieć dostęp do repo (pisz do Kuby Nabrdalika)

* lokalnie musisz mieć brancha gh-pages:

    git fetch origin

    git checkout -b gh-pages origin/gh-pages 

* musisz być na branchu master

* musisz mieć wszystkie zmiany wrzucone, pull i push do mastera

* odpalasz skrypt:

   ./scripts/deploy.sh

* powinno działać

# Co ja kodzę, czyli czego używamy tak naprawdę:

[angular-brunch-seed](https://github.com/scotch/angular-brunch-seed)

### Using Jade

You will find the jade files in the `app` and `app/partials` directories. Upon save the Jade files will be compiled to HTML
and placed in the `app/assets` folder. Do not modify the files in the `app/assets` folder as they will be overriden with subsequent
changes to their `*.jade` counter part.

### Using html

By default angular-brunch-seed uses jade templates. If you would prefer to use HTML run the command:

```
./scripts/compile-html.sh
```
All Jade file will be compiled to HTML and be placed in the `app/assets` directory. Addtionally, the `*.jade`
files will be removed from the project. Any changes that you make to the `app/assets/**/*.html` files will now appear in the
browser.

### Running the app during development

* `./scripts/server.sh` to serve using **Brunch**

Then navigate your browser to [http://localhost:3333](http://localhost:3333)

NOTE: Occasionally the scripts will not load properly on the initial
load. If this occurs, refresh the page. Subsequent refresh will render
correctly.

### Running the app in production

* `./scripts/production.sh` to minify javascript and css files.

Please be aware of the caveats regarding Angular JS and minification, take a look at [Dependency Injection](http://docs.angularjs.org/guide/di) for information.

## Directory Layout

    _public/                  --> Contains generated file for servering the app
                                  These files should not be edited directly
    app/                      --> all of the files to be used in production

      assets                  --> a place for static assets. These files will be copied to
                                  the public directory un-modified.
        font/                 --> [fontawesome](http://fortawesome.github.com/Font-Awesome/) rendering icons
          fontawesome-webfont.*
        img/                  --> image files
        partials/             --> angular view partials (partial HTML templates)
          nav.html                If you are using HTML you may modify these files directly.
          partial1.html           If you are using Jade these file will be update from their *.jade counterpart
          partial2.html
        index.html            --> app layout file (the main html template file of the app).

      partials/               --> Jade partial files. This file will be converted to HTML upon save.
        nav.jade              If you are using HTML this directory will not be present. You will find the template file
        partial1.jade         in the `app/assets/partials` directory instead.
        partial2.jade         If you are using Jade these file will be converted to HTML and copied to `app/assets/partials` upon save.
      scripts/                --> base directory for app scripts
        controllers.js        --> application controllers
        directives.js         --> custom angular directives
        filters.js            --> custom angular filters
        services.js           --> custom angular services

      styles/                 --> all custom styles. Acceptable files types inculde:
                                  less, sass, scss and stylus
        themes/               --> a place for custom themes
          custom/             --> starter theme **NOTE the underscore (_). Files begining with an
                                  underscore will not automatically be compiled, they must be imported.
            _override.less    --> styles that should beloaded after bootstrap.
            _variables.less   --> bootstrap variables to be used during the compilation process
        app.less              --> a file for importing styles.
      app.coffee              --> application definition and routes.
      index.jade              --> Index file. This will be converted to assets/index.html on save
      init.coffee             --> application bootstrap

    node_modules              --> NodeJS modules

    scripts/                  --> handy shell scripts
      compile-html.sh         --> compiles *.jade file to *.html file and places them in app/assets
      compile-tests.sh        --> compiles coffeescript test to javascript
      development.sh          --> compiles files and watches for changes
      init.sh                 --> installs node modules
      production.sh           --> compiles and compresses files for production use
      server.sh               --> runs a development server at `http://localhost:3333`
      test.sh                 --> runs all unit tests

    test/                     --> test source files and libraries
      e2e/                    -->
        scenarios.coffee      --> end-to-end specs
      unit/
        controllers.spec.js   --> specs for controllers
        directives.spec.js    --> specs for directives
        filters.spec.js       --> specs for filters
        services.spec.js      --> specs for services
      vendor/
        angular/              --> angular testing libraries
          angular-mocks.js    --> mocks that replace certain angular services in tests

    vendor/
      scripts/                --> angular and 3rd party javascript libraries
        angular/                  files are compiled to `vendor.js`
          angular.js          --> the latest angular js
          angular-*.js        --> angular add-on modules
          version.txt         --> version number
        bootstrap/            --> for responsive layout
          bootstrap-collapse.js
        console-helper.js     --> makes it safe to do `console.log()` always
        jquery-1.8.3.js       --> for use with bootstrap-collapse
      styles/                 --> sapling / sapling themes and 3 party CSS
        bootstrap/            --> boostrap files - **NOTE** the underscore prevents the
          _*.less                 files from automatically being added to application.css
        sapling               --> extends boostrap
          _*.less
        themes                --> themes to extend Bootstrap
          default             --> the default bootstrap theme
            _overrides.less
            _variables.less
          sapling             --> supplemental theme
            _overrides.less
            _variables.less

For more information on angular please check out <http://angularjs.org>
