require 'spec_helper'

RSpec.describe YamlStructureChecker::Checker do
  let(:checker) do
    YamlStructureChecker::Checker.new
  end

  describe '#run' do
    let(:run) do
      checker.run(settings_path) rescue nil
    end
    let(:settings_path) do
      'spec/fixtures/checker/config/yaml_structure_checker.yml'
    end

    it 'Output exclude_paths' do
      exclude_paths = %w[
        spec/fixtures/checker/target/exclude/example.yml
      ]
      expect { run }.to output(
        /Exclude paths:\n  #{exclude_paths.join('\n  ')}/
      ).to_stdout
    end

    it 'Output skip_paths' do
      skip_paths = %w[
        spec/fixtures/checker/target/skip/example.yml
      ]
      expect { run }.to output(
        /Skip paths:\n  #{skip_paths.join('\n  ')}/
      ).to_stdout
    end

    it 'Output ng_paths' do
      ng_paths = %w[
        spec/fixtures/checker/target/failed/alias.yml
        spec/fixtures/checker/target/failed/diff.yml
      ]
      expect { run }.to output(
        /NG paths:\n  #{ng_paths.join('\n  ')}/
      ).to_stdout
    end

    it 'Output count' do
      total = 'Total count: 6'
      exclude = 'Exclude count: 1'
      skip = 'Skip count: 1'
      ok = 'OK count: 2'
      ng = 'NG count: 2'

      expect { run }.to output(
        /#{total}\n#{exclude}\n#{skip}\n#{ok}\n#{ng}/
      ).to_stdout
    end

    describe 'Testing for exceptions' do
      context 'When success' do
        let(:settings_path) do
          'spec/fixtures/checker/config/yaml_structure_checker_for_success.yml'
        end

        it 'Not raise exceptions' do
          expect {
            checker.run(settings_path)
          }.not_to raise_error
        end
      end

      context 'When failed' do
        let(:settings_path) do
          'spec/fixtures/checker/config/yaml_structure_checker_for_failed.yml'
        end

        it 'Raise exceptions' do
          expect {
            checker.run(settings_path)
          }.to raise_error(YamlStructureChecker::Errors::StructureError)
        end
      end
    end
  end

  describe '#test_yaml' do
    let(:test_yaml) do
      checker.test_yaml(path, envs)
    end

    context 'When nested_keys is the same in all environments' do
      let(:path) { 'spec/fixtures/checker/target/success/same.yml' }
      let(:envs) { %w[development test production] }

      it 'ok_count increases by 1 and returns true' do
        expect { test_yaml }.to change { checker.ok_count }.by(1)
        expect(test_yaml).to eq(true)
      end

      it 'Not add path to ng_paths' do
        expect { test_yaml }.not_to change { checker.ng_paths }
        expect(checker.ng_paths).to eq([])
      end
    end

    context 'When different nested_keys' do
      let(:path) { 'spec/fixtures/checker/target/failed/diff.yml' }
      let(:envs) { %w[development test production] }

      it 'ng_count increases by 1 and returns false' do
        expect { test_yaml }.to change { checker.ng_count }.by(1)
        expect(test_yaml).to eq(false)
      end

      it 'Add path to ng_paths' do
        expect { test_yaml }.to change { checker.ng_paths }
        expect(checker.ng_paths).to eq([path])
      end
    end
  end

  describe '#compare' do
    let(:nested_keys) { [%w[a b c], %w[x y z]] }
    let(:envsnested_keys_each_env) do
      {
        'development' => nested_keys.clone,
        'test' => nested_keys.clone,
        'integration' => nested_keys.clone,
        'production' => nested_keys.clone,
      }
    end
    let(:envs) do
      %w[development test integration production]
    end

    context 'When nested_keys is the same in all environments' do
      it 'Return true and no message' do
        expect(
          checker.compare(envsnested_keys_each_env, envs),
        ).to eq({
          success: true,
          compare_message: ''
        })
      end
    end

    context 'When different nested_keys' do
      let(:compare_message) do
"\
Diff:
  test - development:
    a.b.c
    x.y.z
  development - test:
    d.e.f
Diff:
  integration - development:
    a.b.c
    x.y.z
  development - integration:
    d.e.f
Diff:
  production - development:
    a.b.c
    x.y.z
  development - production:
    d.e.f
"
      end

      before do
        envsnested_keys_each_env['development'] = [%w[d e f]]
      end

    it 'Return false and message' do
        expect(
          checker.compare(envsnested_keys_each_env, envs),
        ).to eq({
          success: false,
          compare_message: compare_message,
        })
      end
    end
  end
end
