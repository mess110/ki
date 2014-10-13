# Ki Framework

Tiny REST JSON ORM framework.

Ki's goal is to help you protoype your ideas blazing fast. It has a db backend
and provides a fullblown REST api on top.

## TLDR

To create an api endpoint '/todo.json' with GET/POST/PATCH and restricting
DELETE, with title and description as required attributes, with db backend,
with a unique title, and before/after filters you would need to write:

```ruby
class Todo < Ki::Model
  requires :title, :description
  unique :title
  forbid :delete

  def before_all
    puts 'hello'
  end

  def before_create
    params['created_at'] = Time.now.to_i
  end

  def after_find
    if result['keywords'].include? 'food'
      puts 'yummy'
    end
  end
end
```

List of used stuff:

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

App directory structure:

* public/
  * javascripts/
  * stylesheets/
* views/
* app.rb
* config.yml

The entry point for the app is *app.rb*. You will add most of your code there.
Views are in the *views* folder and you can find some database info in
*config.yml*.

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

If the file *views/layout.haml* exists, it will be used as a layout for all the
other haml files. The content of the route will be placed in the layout *yield*

*views/layout.haml*

```haml
!!!
%html
  %head
    %title Ki Framework
  %body
    = yield
```

*views/index.haml*

```haml
%p Hello World!
```

### Helpers

To reduce complexity in your views, you can use helpers. Here we create a
*say_hello* method which we can use in *views/index.haml*.

*app.rb*

```ruby
module Ki::Helpers
  def say_hello
    'hello'
  end
end
```

*views/index.haml*

```haml
%p= say_hello
```

### Adding a resource

Think of resources as the M in MVC. Except they also have routes attached.
All resources must inherit from Ki::Model. For example, to create a todo model
add the fallowing snippet to *app.rb*

```ruby
class Todo < Ki::Model
end
```

This will create the Todo resource and its corresponding routes. Each route is
mapped to a model method.

Method name | Verb | HTTP request|Required params|
------------|------|-------------|---------------|
find        |GET   | /todo.json  |               |
create      |POST  | /todo.json  |               |
update      |PATCH | /todo.json  |id             |
delete      |DELETE| /todo.json  |id             |

Below is a curl example for creating a todo item. Notice the data sent in the
body request is a JSON string. It can take the shape of any valid JSON object.
All json objects will be stored in the database under the resource name. In our
case *todo*.

#### Create

```shell
curl -X POST -d '{"title": "make a todo tutorial"}' http://localhost:9292/todo.json
```

#### Get all

```shell
curl -X GET http://localhost:9292/todo.json
```

#### Get by id

```shell
curl -X GET http://localhost:9292/todo.json?id=ITEM_ID
```

#### Update

```shell
curl -X PATCH -d '{"id": "ITEM_ID", "title": "finish the todo tutorial"}' http://localhost:9292/todo.json
```

#### Delete

```shell
curl -X DELETE -d http://localhost:9292/todo.json?id=ITEM_ID
```

### Required attributes

You can add mandatory attributes on resources with the *requires* method. It
takes one parameter or an array of parameters as an argument.

```ruby
class Todo < Ki::Model
  requires :title
end
```

This will make sure a Todo item can not be saved or updated in the database
without a title attribute.

### Restricting resource requests

Let's say you want to forbid access to deleting items. You can do that with
the *forbid* method.

```ruby
class Todo < Ki::Model
  forbid :delete
end
```

### Before/after callbacks

The framework has [these callbacks](https://github.com/mess110/ki/blob/master/lib/ki/modules/callbacks.rb).
Here is an example on how to use them:

```ruby
class Todo < Ki::Model
  def before_create
    # do your stuff
  end
end
```

#### Accessing the json object within a callback

Before the request is sent to the client, you can look at the result through
the *result* method. Modifying it will change what the client receives.

```ruby
class Todo < Ki::Model
  def after_find
    puts result
  end
end
```

### Exceptions

A list of exceptions can be found [here](https://github.com/mess110/ki/blob/master/lib/ki/api_error.rb)

```ruby
class Todo < Ki::Model
  def before_all
    ensure_authroization
  end

  private

  def ensure_authorization
    if params[:key] = 'secret-key'
      raise UnauthorizedError.new
    end
  end
end
```
