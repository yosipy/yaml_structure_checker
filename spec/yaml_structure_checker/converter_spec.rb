require 'spec_helper'

RSpec.describe YamlStructureChecker::Converter do
  describe 'self.hash_to_nested_keys' do
    let!(:hash) do
      {
        'development' => {
          'x' => 1,
          'y' => 2,
          'z' => 3,
        },
        'test' => {
          'p' => {
            'q' => {
              'r' => 4,
            },
          },
          's' => {
            't' => {
              'u' => 5,
            },
          },
        },
        'production' => 6,
      }
    end

    it 'Returns the nested structure of keys as an array' do
      expect(
        YamlStructureChecker::Converter.hash_to_nested_keys(hash)
      ).to eq(
        [
          %w[development x],
          %w[development y],
          %w[development z],
          %w[test p q r],
          %w[test s t u],
          %w[production],
        ],
      )
    end
  end

  describe 'self.nested_keys_to_nested_keys_each_env' do
    let(:nested_keys) do
      [
        %w[development x],
        %w[development y],
        %w[development z],
        %w[test p q r],
        %w[test s t u],
        %w[production],
      ]
    end
    let(:envs) { %w[development test production] }

    it 'Returns a hash of nested_keys grouped by environment' do
      expect(
        YamlStructureChecker::Converter
          .nested_keys_to_nested_keys_each_env(
            nested_keys,
            envs,
          ),
      ).to eq(
        {
          'development' => [['x'], ['y'], ['z']],
          'test' => [%w[p q r], %w[s t u]],
          'production' => [[]],
        },
      )
    end
  end
end
