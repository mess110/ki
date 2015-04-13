# Ki Framework

Ki uses middleware to provide a plug-n-play way of customizing requests.
Rack handles everything™

## Middleware

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

## Make your own

TODO

### config.yml

TODO middleware config example.
