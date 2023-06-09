![thumbnail](yaml_structure_checker.png)

# YAML structure checker

This Gem can detect that the keys in the yaml file do not match for each environment.

This prevents cases where errors occur only in the production environment.

It works powerfully in Rails, but of course it can be used in other applications as well.

The following is an example

```yaml
# This file is OK.
development: &default
  db:
    username: username
    password: password

test:
  <<: *default

integration:
  <<: *default

production:
  <<: *default
  db:
    username: <%= ENV['DATABASE_UERNAME'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
```

```yaml
# This file is NG. Raises an exception.
development: &default
  db:
    username: username
    password: password

test:
  <<: *default

integration:
  <<: *default

production:
  <<: *default
  db:
    username: <%= ENV['DATABASE_UERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml_structure_checker'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install yaml_structure_checker
```

## Usage

### Add configuration file

Add the configuration file `config/yaml_structure_checker.yml`.

YAML structure checker loads `config/yaml_structure_checker.yml` by default.

An example follows

```yaml
# config/yaml_structure_checker.yml
include_patterns:
  - config/**/*.yml
exclude_patterns:
  - config/locales/**/*.yml
envs:
  - development
  - test
  - integration
  - production
skip_paths:
  - config/gcp.yml
```

|                  |                                                                           |
| ---------------- | ------------------------------------------------------------------------- |
| include_patterns | Specifies the pattern of files to inspect for keys.                       |
| exclude_patterns | Specifies patterns to exclude from include_patterns.                      |
| envs             | Specifies the environment in which comparisons will be made by the check. |
| skip_paths       | Specifies file paths to exclude from include_patterns.                    |
|                  |                                                                           |

### Check yaml files

Run the `yaml_structure_checker` command to check your YAML files.

```bash
$ bundle exec yaml_structure_checker

#################################
#     YAML Structure Check      #
#################################

Exclude paths:
  spec/fixtures/checker/target/exclude/example.yml
  spec/fixtures/checker/target/failed/alias.yml
  spec/fixtures/checker/target/failed/diff.yml

Skip paths:
  spec/fixtures/checker/target/skip/example.yml


# spec/fixtures/checker/target/success/alias.yml
Result: OK


# spec/fixtures/checker/target/success/same.yml
Result: OK

#################################
#  YAML Structure Check Result  #
#################################

NG paths:
  nothing

Total count: 6
Exclude count: 3
Skip count: 1
OK count: 2
NG count: 0
```

If you want to use a configuration file other than `config/yaml_structure_checker.yml`, do the following

```bash
$ bundle exec yaml_structure_checker other_yaml_faile_path.yml
```

### Run on CI

It is recommended to run it through CI.

The following is an example of Github Actions.

```yaml
name: CI

on: push

jobs:
  ci:
    name: CI
    runs-on: ubuntu-latest
    container:
      image: ruby:3.2.2
    steps:
      - uses: actions/checkout@v2
      - name: Bundle install
        run: bundle install --path=vendor/bundle --jobs 4 --retry 3
      - name: YAML structure checker
        run: bundle exec yaml_structure_checker
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Also, you can use Docker.

```bash
docker-compose run --rm app /bin/bash
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yosipy/yaml_structure_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yosipy/yaml_structure_checker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YAMLStructureChecker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yosipy/yaml_structure_checker/blob/master/CODE_OF_CONDUCT.md).
