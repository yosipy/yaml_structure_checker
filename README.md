# Yaml structure checker

This Gem can detect that the keys in the yaml file do not match for each environment.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

### Add configuration file

Add the configuration file `config/yaml_structure_checker.yml`.

Yaml structure checker loads `config/yaml_structure_checker.yml` by default.

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

Run the `yaml_structure_checker` command to check your Yaml files.

```bash
$ bundle exec yaml_structure_checker

#################################
#     Yaml Structure Check      #
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
#  Yaml Structure Check Result  #
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
      - name: Yaml structure checker
        run: bundle exec yaml_structure_checker
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yaml_structure_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/yaml_structure_checker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YamlStructureChecker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yaml_structure_checker/blob/master/CODE_OF_CONDUCT.md).
