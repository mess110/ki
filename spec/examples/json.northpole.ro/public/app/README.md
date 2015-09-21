# Angular Material-Start

This is a template project. It customizes [this](https://github.com/angular/material-start).

Extra features

* updated angular-material version
* gulp
* coffee-script

## Getting Started

#### Clone material-start

```bash
git clone --depth=1 https://github.com/mess110/material-start.git <your-project-name>
```

#### Install Dependencies

```
npm install
```

### Run End-to-End Tests

To run your e2e tests your should install and configure Protractor and the Selenium WebServer.
These are already specified as npm dependencies within `package.json`. Simply run these
terminal commands:

```console
npm update
webdriver-manager update
```

Your can read more details about Protractor and e2e here: http://angular.github.io/protractor/#/
for more details on Protractor.

 1. Start your local HTTP Webserver: `live-server` or `http-server`.

```console
cd ./app; live-server;
```

> Note: since `live-server` is working on port 8080, we configure the `protractor.conf.js` to use
`baseUrl: 'http://localhost:8080'`

 2. In another tab, start a Webdriver instance:
 
```console
webdriver-manager start
```

>This will start up a Selenium Server and will output a bunch of info logs. Your Protractor test
will send requests to this server to control a local browser. You can see information about the
status of the server at `http://localhost:4444/wd/hub`. If you see errors, verify path in
`e2e-tests/protractor.conf.js` for `chromeDriver` and `seleniumServerJar` to your local file system.

 3. Run your e2e tests using the `test` script defined in `package.json`:
 
```console
npm test
```

> This uses the local **Protractor** installed at `./node_modules/protractor`

## Directory Layout

```
build/                  --> "compiled" version of the project
src/                    --> all of the source files for the application
  assets/               --> default assets
  directives/           --> directives
  users/                --> package for user features
    views/              --> user related views
  app.sass              --> app sass file
  index.html            --> app layout file (the main html template file of the app)
e2e-tests/              --> end-to-end tests
  protractor-conf.js    --> Protractor config file
  scenarios.js          --> end-to-end scenarios to be run by Protractor
karma.conf.js           --> config file for running unit tests with Karma
```
