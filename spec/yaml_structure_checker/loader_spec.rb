require 'spec_helper'

RSpec.describe YamlStructureChecker::Loader do
  let(:loader) do
    YamlStructureChecker::Loader.new('spec/fixtures/loader/yaml_structure_checker.yml')
  end

  describe '#initialize' do
    it 'Loaded Yaml values' do
      expect(loader.include_patterns).to eq(%w[spec/fixtures/loader/**/*.yml])
      expect(loader.exclude_patterns).to eq(%w[spec/fixtures/loader/locales/**/*.yml])
      expect(loader.envs).to eq(
        %w[development test integration production]
      )
      expect(loader.skip_paths).to eq(%w[spec/fixtures/loader/skip.yml])
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
      it 'Raise error' do
        expect {
          loader
            .send(:exist_files?, %w[spec/fixtures/loader/not_exist.yml])
        }.to raise_error(YamlStructureChecker::Errors::LoaderError)
      end
    end
  end
end
