## Attention: This is Barely Alpha ##

It should work for almost all versions of hacker news you find in the
wild.

It's opinionated and uses sendgrid  at the moment, but you could change
that up if you want.

If you wanna wire things up fill in the relevant constants in
lib/credentials.rb and run it.  Simple.

----------

## Todo ##

* Split out the relevant portions into lib (extracted two methods)
* Read in a YAML config file for the settings
* Complete the transition to using HAML
  * Make the html_digest render take a collection of scraped_links rather than just passing it rendered li_links
* Setup a simple way to cron this from a user's perspective (rake task)
* Gemify
* Release
