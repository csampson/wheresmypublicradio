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

Using Karma to automatically handle AngularJS unit tests:

```
karma start spec/angular/unit/karma.conf.js
```

End-to-end testing using Protractor:

```
protractor spec/angular/e2e/protractor.conf.js
```

## Contributing

If you see something you'd like to change/improve, feel free to [create an issue ](https://github.com/csampson/wheresmypublicradio/issues). Also, craft beer purchases for local nola contributors.

## License

[MIT](http://opensource.org/licenses/MIT)
