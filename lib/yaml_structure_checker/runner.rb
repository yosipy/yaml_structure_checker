module YAMLStructureChecker
  class Runner
    def self.invoke(settings_path)
      if settings_path.nil?
        settings_path='config/yaml_structure_checker.yml'
      end

      Checker.new.test_yamls(settings_path)
    end
  end
end
