require 'spec_helper'

RSpec.describe YamlStructureChecker::Runner do
  describe 'self.invoke' do
    let(:settings_path) do
      'spec/fixtures/runner/config/yaml_structure_checker.yml'
    end

    it 'Call YamlStructureChecker::Checker.new.test_yamls' do
      checker = instance_double(YamlStructureChecker::Checker)
      allow(YamlStructureChecker::Checker).to receive(:new).and_return(checker)
      allow(checker).to receive(:test_yamls).and_return(nil)

      YamlStructureChecker::Runner.invoke(settings_path)
      expect(checker).to have_received(:test_yamls).with(settings_path).once
    end
  end
end
