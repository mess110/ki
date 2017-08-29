# Ki Framework

Ki uses middleware to provide a plug-n-play way of customizing requests.
Rack handles everything™

## Middleware

It is configured in the config.yml of the application.

The default enabled middleware list:

* ApiHandler
* CoffeeCompiler
* SassCompiler
* HamlCompiler
* PublicFileServer

### ApiHandler

Handles all api calls.

### CoffeeCompiler

On request, compiles coffee to js.

For example, if you have a file *public/javascripts/app.coffee*, accessing
*/public/javascripts/app.js* will return the compiled coffee file.

### SassCompiler

Similar to CoffeeCompiler, compiles sass to css.

### HamlCompiler

Similar to CoffeeCompiler, compiles haml to html.

### PublicFileServer

Serves static files from the *public/* folder.

### example middleware configuration

```yml
development:
  database:
    name: base_development
    host: 127.0.0.1
    port: 27017
  add_middleware: ['Realtime', 'InstaDoc', 'AdminInterfaceGenerator']
  rm_middleware: ['SassCompiler']

test:
  database:
    name: np_test
    host: 127.0.0.1
    port: 27017

production:
  middleware: ['ApiHandler', 'PublicFileServer']
  add_middleware: ['Realtime', 'InstaDoc', 'AdminInterfaceGenerator']
  database:
    name: np
    host: 127.0.0.1
    port: 27017
```
