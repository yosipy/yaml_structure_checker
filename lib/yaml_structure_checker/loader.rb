require 'yaml'

module YAMLStructureChecker
  class Loader
    attr_accessor :include_patterns,
                  :exclude_patterns,
                  :envs,
                  :skip_paths

    def initialize(settings_path)
      hash =
        begin
          Loader.yaml_safe_load_file(settings_path)
        rescue => e
          puts "Not found YAMLStructureChecker's settings file."
          raise e
        end

      self.include_patterns = hash['include_patterns'].freeze
      self.exclude_patterns = (hash['exclude_patterns'] || []).freeze
      self.envs = hash['envs'].freeze
      self.skip_paths = (hash['skip_paths'] || []).freeze

      exist_files?(self.skip_paths)
    end

    def self.yaml_load_file(path)
      if RUBY_VERSION > '3.1.0'
        YAML.load_file(path, aliases: true)
      else
        YAML.load_file(path)
      end
    end

    def self.yaml_safe_load_file(path)
      if RUBY_VERSION > '3.1.0'
        YAML.safe_load_file(path)
      else
        YAML.load_file(path)
      end
    end

    def target_paths
      @target_paths ||=
        begin
          include_paths = file_paths(self.include_patterns)
          (include_paths - exclude_paths - self.skip_paths).sort.freeze
        end
    end

    def exclude_paths
      @exclude_paths ||= file_paths(exclude_patterns).sort.freeze
    end

    def total_count
      target_paths.size + exclude_paths.size + skip_paths.size
    end

    private

    def file_paths(patterns)
      paths = []
      patterns.each do |pattern|
        paths += Dir.glob(pattern)
      end
      paths.uniq.sort
    end

    def exist_files?(paths)
      paths.each do |path|
        unless File.exist?(path)
          raise YAMLStructureChecker::Errors::LoaderError, "Not found '#{path}'"
        end
      end

      true
    end
  end
end
