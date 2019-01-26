# mocha_to_rspec

This gem is to help migrating from [mocha] to [rspec-mocks].

It uses RuboCop to perform the conversion.

It converts the syntax, for example:

```ruby
widget.stubs(:foo).returns(bar)
```

to

```ruby
allow(widget).to receive(:foo).and_return(bar)
```

It does not handle _every_ conversion, but should get you most of the way there.

You might it useful to use this alongside [rspec-multi-mock]

[mocha]: https://github.com/freerange/mocha
[rspec-mocks]: https://github.com/rspec/rspec-mocks
[rspec-multi-mock]: https://github.com/endeepak/rspec-multi-mock

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mocha_to_rspec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mocha_to_rspec

## Usage

The individual cops can be run through RuboCop, and you can pass the
`--auto-correct` flag. However, it really only makes sense to run all the cops
together, so a single command is provided:

```ruby
mocha_to_rspec [path]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

I wrote this for use on one particular project so I probably won't be doing any
further work on it, but pull requests are welcome if accompanied by tests.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
