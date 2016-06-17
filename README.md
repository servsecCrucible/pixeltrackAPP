# PixeltrackAPP

UI App for Pixeltrack API

![pixel](http://pixeltrack-api.heroku.com/19fbf71b-8e56-4266-843e-829d71818898.png)

## Install

Install this API by cloning the *relevant branch* and installing required gems:

    $ bundle install

Create a configuration file to store MSG_KEY. Be sure to use separate key
for development and production.

    $ touch config_env.rb
    $ gedit config_env.rb
    $ rake key:symmetric:generate (Generate MSG_KEY)
    $ rake key:asymmetric:generate (Generate PGP Pair)

    Edit config_env.rb file according to config_env.rb.example

## Testing

## Execute
Run the app:

    $ RACK_ENV=test bundle exec rackup [Use test branch]
    $ RACK_ENV=production bundle exec rackup [Use production branch]
    $ bundle exec rackup [Default to development branch]

## Location
[Deployed instance](https://pixeltrack-app.herokuapp.com "PixelTrackAPP")
