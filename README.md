# Ki Framework

Tiny REST JSON ORM framework.

Ki's goal is to help you protoype your ideas blazing fast. It has a db backend
and provides a fullblown REST api on top.

* rvm
* mongodb
* haml
* sass
* coffee

## Install

```shell
gem install ki
```

## Getting started

Learn by example. We will create the traditional 'hello world' app for web
development: the dreaded TODO app.

View the [code](https://github.com/mess110/ki/tree/master/spec/examples/todo) for
the final webapp.

### Creating a new app

```shell
ki new todo
```

This will create the folder *todo* containing a bare bones ki application. Your
app will look [like this](https://github.com/mess110/ki/tree/master/spec/examples/base).

```shell
cd todo
bundle
rackup
```

*rackup* is the command which starts the webserver. The port will be displayed.

### Adding a view

A view is a html page. By default, a view called 'index.haml' is created for
you in the 'views/' folder. All haml files from the '/views/' folder are
compiled to html at runtime.

For example, to serve a html file when a user accesses '/dashboard' create the
'views/dashboard.haml' dashboard.

### Adding assets

All files from the 'public/' folder are served to the client from the root url.

You can add any type of file. Coffee and sass files are compiled at runtime,
similar to haml.

### View layout

TODO

### Adding a resource

TODO

### Restricting resource requests

TODO

### Before/after filters

TODO
