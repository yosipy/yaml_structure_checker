# frozen_string_literal: true

require_relative "lib/yaml_structure_checker/version"

Gem::Specification.new do |spec|
  spec.name = "yaml_structure_checker"
  spec.version = YAMLStructureChecker::VERSION
  spec.authors = ["yosipy"]
  spec.email = ["yosi.contact@gmail.com"]

  spec.summary = "YAML structure checker in ruby"
  spec.description = "This Gem can detect that the keys in the yaml file do not match for each environment. This prevents cases where errors occur only in the production environment."
  spec.homepage = "https://github.com/yosipy/yaml_structure_checker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yosipy/yaml_structure_checker"
  spec.metadata["changelog_uri"] = "https://github.com/yosipy/yaml_structure_checker/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = %w[yaml_structure_checker]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
