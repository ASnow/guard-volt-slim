# Guard::VoltSlim

Guard that compile slim to sandlebar templates

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'guard-volt-slim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-volt-slim

Add config to Guardfile

    $ bundle exec guard init guard-volt-slim
    
## Usage

Run guard

    $ bundle exec guard

Put your slim templates at 'app/:component/_views' and on change they will be converted and copied to 'app/:component/views'


Write your slim like this

In:
```slim
tpl-title
  | App title
tpl-body
  | ...
  use-sucess-alert
  | ...
tpl-sucess-alert
  .alert
    Your alert
```
OUT:
```slim
<:Title>
  App title
<:Body>
  ...
  <:sucess-alert></:sucess-alert>
  ...
<:Sucess-alert>
  .alert
    Your alert
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/guard-volt-slim.

