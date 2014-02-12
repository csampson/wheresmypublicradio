# Where's My Public Radio?

## Overview

This is an NPR member station finder and radio-streamer application built on Sinatra+AngularJS.

## Setup

I'm using Ruby 2.x myself; handle appropriately.

Install gems:

```
bundle install
```

Installing Karma and Protractor:

```
npm install -g karma
npm install -g protractor
```

Register for an NPR api key by signing up for an account at http://www.npr.org/templates/reg/, then copy over the .env.example file to .env and edit with your api key.

Running the application:
```
rackup
```

## Testing

You can use Guard to test RSpec specs in the background:

```
bundle exec guard
```

Or manually run tests within the Guard shell:

```
all rspec
```

Using Karma to automatically handle AngularJS unit tests:

```
sh scripts/ng_unit.sh
```

End-to-end testing using Protractor:

```
webdriver-manager start
sh scripts/ng_e2e.sh
```

## Contributing

If you see something you'd like to change/improve, feel free to [create an issue ](https://github.com/csampson/wheresmypublicradio/issues). Also, craft beer purchases for local nola contributors.

## License

[GPL](http://opensource.org/licenses/gpl-3.0.html)
