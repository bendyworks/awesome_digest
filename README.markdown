## Attention: This is Barely Alpha ##

It should work for almost all versions of hacker news you find in the
wild.

It's opinionated and uses sendgrid  at the moment, but you could change
that up if you want.

If you wanna wire things up fill in the relevant constants in
lib/credentials.rb and run it.  Simple.

----------

## Todo ##

* Split out the relevant portions into lib
* Read in a YAML config file for the settings
* Allow some flexibility with the layout
* Setup a simple way to cron this from a user's perspective (rake task)
* Gemify
* Release
