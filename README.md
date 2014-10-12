# Ki Framework

Tiny REST JSON ORM framework

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

### Creating a new app

```shell
ki new my-app
cd my-app
bundle
```

This will create the folder *my-app* containing a bare bones ki application.

```shell
rackup
```

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
