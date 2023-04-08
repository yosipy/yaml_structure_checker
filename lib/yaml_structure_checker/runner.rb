module YamlStructureChecker
  class Runner
    def self.invoke(settings_path='config/yaml_structure_checker.yml')
      Checker.new.test_yamls(settings_path)
    end
  end
end
