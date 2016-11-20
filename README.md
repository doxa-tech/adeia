# Adeia

An discretionary authorization gem for Rails that allows you to have the complete control of your app.

## Requirements

Requires a User model with:

* An method `name`, returning the name of the user.
* A column `remember_token`, containing a generated token used for the authentification.

```
rails g model User name:string remembre_token:string
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adeia'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adeia

Then include the engine's routes in your `routes.rb`. The URL on which you mount the engine is up to you.

```ruby
# routes.rb

mount Adeia::Engine => "/adeia"
```

Finally copy the migrations by running `rake adeia:install:migrations` in your terminal.

### Tasks

The first task to run is `rake adeia:permissions elements="first_element, second_element"`. It creates the given elements in the database and a superadmin group which has all the permissions.
Then you can run `rake adeia:superuser user_id=your_id`, which add the given user in the superadmin group.
If you need to add new groups, run `rake adeia:groups groups="first_group, second_group"`.

For example:

```
rake adeia:permissions elements="admin/galleries, admin/articles, admin/categories"
rake adeia:superuser user_id=59
```

## Documentation

### Authentification

Adeia provides methods to sign in and out, to get or set the current user and to check if a user is signed in.

```ruby

# sign in an user
sign_in @user
# alternatively, sign in permanently
sign_in @user, permanent: true

# get and set the connected user
current_user # => #<User>
current_user = @an_other_user

# check if the user is signed in
if signed_in?
  # Do stuff
end

```

### Authorization

There are four different authorization methods at action-level.

`require_login!` checks if the user is signed in. It raises the exception `LoginRequired` if not.

```ruby
def index
  require_login!
  @events = Event.all
end
```

`authorize!` checks if the user has the permissions to access the action. It raises `AccessDenied` if not.

```ruby
def new
  authorize!
  @event = Event.new
end
```

`load_and_authorize!` loads the suitable record and checks if the user has the permissions to access the action, taking into account the loaded record. It raises `AccessDenied` if not.
The method returns the record, but it also automatically set an instance variable named after the model.

```ruby
def edit
  @event = load_and_authorize!
  # assignation is optional here
end
```

`authorize_and_load_records!` loads the records taking into account the user's permissions. It raises `AccessDenied` if the user hasn't access to any records.

```ruby
def index
  @events = authorize_and_load_records!
  # assignation is optional here
end
```

By default, the methods (except `require_login!`) use the following parameters:

* controller: the controller's name
* action: the action's name
* token: GET parameter `token`
* resource: fetch the resource from controller's name

You can override those parameters when invoking the method:

```ruby
def index
  authorize!(controller: 'events', action: 'new')
end
```
Adeia also provide controller-level methods to keep your code DRY.

`require_login` adds the `require_login!` method to the controller's actions.

`load_and_authorize` adds the suitable methods to the controller's actions:

* index: `authorize_and_load_records!`
* show, edit, update, destroy: `load_and_authorize!`
* new, create, other actions: `authorize!`

The two controller-level methods accepts the restricting parameters `only` and `except`.

```ruby
class EventsController < ApplicationController

  require_login only: [:postpone]
  load_and_authorize, except: [:postpone]

  def index; end

  def new; end

  def create; end

  def postpone; end

end
```

### Controller methods

When an authorization exception is raised by the engine, it automatically store the current user's location in a cookie. The called method is `store_location` and is available in your controllers. Then you can use the method `redirect_back_or(default, message = nil)` which either redirects to the stored location if any or redirects the default provided path, with an optional message.

## Model methods

TODO

* User model
* Permission model
