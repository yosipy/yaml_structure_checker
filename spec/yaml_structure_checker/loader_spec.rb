require 'spec_helper'

RSpec.describe YAMLStructureChecker::Loader do
  let(:loader) do
    YAMLStructureChecker::Loader.new('spec/fixtures/loader/yaml_structure_checker.yml')
  end

  describe '#initialize' do
    it 'Loaded YAML values' do
      expect(loader.include_patterns).to eq(%w[spec/fixtures/loader/**/*.yml])
      expect(loader.exclude_patterns).to eq(%w[spec/fixtures/loader/locales/**/*.yml])
      expect(loader.envs).to eq(
        %w[development test integration production]
      )
      expect(loader.skip_paths).to eq(%w[spec/fixtures/loader/skip.yml])
    end
  end

  describe 'self.yaml_load_file' do
    it 'Convert yaml file to hash' do
      expect(
        YAMLStructureChecker::Loader.yaml_load_file(
          'spec/fixtures/loader/yaml_structure_checker.yml'
        )
      ).to eq({
        'envs' => %w[development test integration production],
        'exclude_patterns' => %w[spec/fixtures/loader/locales/**/*.yml],
        'include_patterns' => %w[spec/fixtures/loader/**/*.yml],
        'skip_paths' => %w[spec/fixtures/loader/skip.yml]
      })
    end
  end

  describe 'self.yaml_safe_load_file' do
    it 'Convert yaml file to hash' do
      expect(
        YAMLStructureChecker::Loader.yaml_safe_load_file(
          'spec/fixtures/loader/yaml_structure_checker.yml'
        )
      ).to eq({
        'envs' => %w[development test integration production],
        'exclude_patterns' => %w[spec/fixtures/loader/locales/**/*.yml],
        'include_patterns' => %w[spec/fixtures/loader/**/*.yml],
        'skip_paths' => %w[spec/fixtures/loader/skip.yml]
      })
    end
  end

  describe '#target_paths' do
    it do
      expect(loader.target_paths).to eq(
        %w[
          spec/fixtures/loader/0.yml
          spec/fixtures/loader/1.yml
          spec/fixtures/loader/yaml_structure_checker.yml
        ]
      )
    end
  end

  describe '#exclude_paths' do
    it do
      expect(loader.exclude_paths).to eq(
        %w[
          spec/fixtures/loader/locales/en.yml
          spec/fixtures/loader/locales/ja.yml
        ]
      )
    end
  end

  describe '#total_count' do
    it 'return total count of target_paths & exclude_paths & skip_paths' do
      expect(loader.total_count).to eq(6)
    end
  end

  describe '#exist_files?' do
    context 'When the path where all files exist' do
      it 'Return true' do
        expect(
          loader
            .send(:exist_files?, %w[spec/fixtures/loader/skip.yml])
          ).to eq(true)
      end
    end

    context 'When there is a path for a file that does not exist' do
      it 'Raise exceptions' do
        expect {
          loader
            .send(:exist_files?, %w[spec/fixtures/loader/not_exist.yml])
        }.to raise_error(YAMLStructureChecker::Errors::LoaderError)
      end
    end
  end
end
