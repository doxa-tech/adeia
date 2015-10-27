# Adeia

An authorization gem for Rails that allows you to have the complete control of your app.

## Requirement

Require a User model with:

* An method `name`, returning the name of the user.
* A column `remember_token`, containing a generated token. It is used for the authentification.
* An admin user, with the name "admin"