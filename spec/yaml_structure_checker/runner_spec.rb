require 'spec_helper'

RSpec.describe YAMLStructureChecker::Runner do
  describe 'self.invoke' do
    let(:settings_path) do
      'spec/fixtures/runner/config/yaml_structure_checker.yml'
    end

    it 'Call YAMLStructureChecker::Checker.new.test_yamls' do
      checker = instance_double(YAMLStructureChecker::Checker)
      allow(YAMLStructureChecker::Checker).to receive(:new).and_return(checker)
      allow(checker).to receive(:test_yamls).and_return(nil)

      YAMLStructureChecker::Runner.invoke(settings_path)
      expect(checker).to have_received(:test_yamls).with(settings_path).once
    end
  end
end
