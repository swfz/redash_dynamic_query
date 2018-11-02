[![Gem Version](https://badge.fury.io/rb/redash_dynamic_query.svg)](https://badge.fury.io/rb/redash_dynamic_query)

# RedashDynamicQuery

execute query to redash with dynamic parameter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redash_dynamic_query'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redash_dynamic_query

## Usage


```
redash = RedashDynamicQuery::Client.new(user_apikey: 'xxxxxx', endpoint: 'https://......')
params = {
  from: '2018-10-01',
  to: '2018-10-31'
}
result = redash.query(query_id: 1, params: params)

p result['query_result']['data']

# {
#   "columns" => [
#     {"friendly_name"=>"name", "type"=>"string", "name"=>"name"},
#     {"friendly_name"=>"id", "type"=>"string", "name"=>"id"}
#   ],
#   "rows" => [
#     {"id" => 1, "name" => 'hoge'},
#     {"id" => 2, "name" => 'fuga'},
#     {"id" => 3, "name" => 'piyo'}
#   ]
# }
```

## Options
- user_apikey
    - API Key in Redash(related user)
- endpoint
    - Redash url
- interval
    - polling interval(seconds)
- timeout
    - wait timeout seconds.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redash_dynamic_query. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RedashDynamicQuery project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/redash_dynamic_query/blob/master/CODE_OF_CONDUCT.md).
