[![Build Status](https://travis-ci.org/fw42/cubecomp.svg?branch=master)](https://travis-ci.org/fw42/cubecomp)
[![security](https://hakiri.io/github/fw42/cubecomp/master.svg)](https://hakiri.io/github/fw42/cubecomp/master)
[![Dependency Status](https://gemnasium.com/fw42/cubecomp.svg)](https://gemnasium.com/fw42/cubecomp)

# Cubecomp

Cubecomp is a web application written in Ruby on Rails which is used by
several members of the World Cube Association (WCA) and volunteers around
the world to organize Rubik's Cube competitions.

The website features a rich adminstration interface with many useful features
for competition organizers, such as creating a public website with a registration
form, creating event schedules, confirming competitor registrations, generating
printable nametags, and much more.

Since early 2009, cubecomp (or earlier versions of it) has been used to host
over 85 different competitions in at least 5 different countries around the
world.

Cubecomp is free and open source, published under the
[MIT license](https://en.wikipedia.org/wiki/MIT_License).

## How do I use cubecomp?

If you are a competition organizer and want to use cubecomp to host your website,
you can either run it on your own server or you can use our hosted version on
https://cubecomp.de. Please send an email to cubecomp@cubecomp.de if you would
like us to create an account for you.

### Can I use your hosted version of cubecomp, but use a different domain?

We can make this work. Send an email to cubecomp@cubecomp.de.

### Cubecomp doesn't support my country's native language

I'm happy to add more languages. Send an email to cubecomp@cubecomp.de
and we can work on a translation (or take a look at
[config/locales/en.yml](https://github.com/fw42/cubecomp/blob/master/config/locales/en.yml)
and send me a translated version of that for your language).

## Screenshots

![Screenshots](https://cloud.githubusercontent.com/assets/2072686/7221699/d0707a2c-e6c3-11e4-97f3-ed1ee295a399.gif)

## Getting started

### Requirements

* Ruby 2.0 or higher
* MySQL or SQLite
* gem and bundler

### Development

Clone the repository:
```
git clone git@github.com:fw42/cubecomp.git
cd cubecomp
```

Install dependencies:
```
bundle install
```

The default database is MySQL. If you want to use SQLite, please edit
"config/database.yml" and "Gemfile" accordingly and run `bundle install`.

Generate the database:
```
bundle exec rake db:setup db:seed:countries db:seed:themes
```

Import the WCA database:
```
bundle exec rake db:load_wca_schema db:seed:wca
```

Generate an example competition and some example users:
```
bundle exec rake db:seed:example_competition
```

Start a local webserver:
```
bundle exec rails server
```

Visit [http://localhost:3000/admin](http://localhost:3000/admin) in a browser and log in with
email "admin@admin.com", password "admin123".
