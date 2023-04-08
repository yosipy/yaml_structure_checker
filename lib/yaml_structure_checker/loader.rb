require 'yaml'

module YamlStructureChecker
  class Loader
    attr_accessor :include_patterns,
                  :exclude_patterns,
                  :envs,
                  :skip_paths

    def initialize(file_path='config/yaml_structure_checker.yml')
      hash = 
        begin
          YAML.safe_load_file(file_path)
        rescue => e
          puts "Not found YamlStructureChecker's settings file."
          raise e
        end

      self.include_patterns = hash['include_patterns'].freeze
      self.exclude_patterns = (hash['exclude_patterns'] || []).freeze
      self.envs = hash['envs'].freeze
      self.skip_paths = (hash['skip_paths'] || []).freeze

      exist_files?(self.skip_paths)
    end

    def target_paths
      @target_paths ||=
        begin
          include_paths = file_paths(self.include_patterns)
          (include_paths - exclude_paths - self.skip_paths).freeze
        end
    end

    def exclude_paths
      @exclude_paths ||= file_paths(exclude_patterns).freeze
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
      paths.uniq
    end

    def exist_files?(paths)
      paths.each do |path|
        unless File.exist?(path)
          raise YamlStructureChecker::Errors::LoaderError, "Not found '#{path}'"
        end
      end

      true
    end
  end
end
