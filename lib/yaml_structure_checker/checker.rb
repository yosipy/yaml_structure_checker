module YAMLStructureChecker
  class Checker
    attr_accessor :ok_count,
                  :ng_count,
                  :ng_paths

    def initialize
      self.ok_count = 0
      self.ng_count = 0
      self.ng_paths = []
    end

    def test_yamls(settings_path)
      print_start_title

      loader = Loader.new(settings_path)
      print_exclude_paths(loader.exclude_paths)
      print_skip_paths(loader.skip_paths)

      results = loader.target_paths.map do |target_path|
        test_yaml(target_path, loader.envs)
      end

      print_result_title

      print_ng_paths(self.ng_paths)

      puts "Total count: #{loader.total_count}"
      puts "Exclude count: #{loader.exclude_paths.size}"
      puts "Skip count: #{loader.skip_paths.size}"
      puts "OK count: #{ok_count}"
      puts "NG count: #{ng_count}"

      raise Errors::StructureError if results.include?(false)
    end

    def test_yaml(path, envs)
      puts "\n# #{path}"

      yaml = Loader.yaml_load_file(path)

      nested_keys = Converter.hash_to_nested_keys(yaml)

      nested_keys_each_env =
        Converter.nested_keys_to_nested_keys_each_env(
          nested_keys,
          envs
        )

      result = compare(nested_keys_each_env, envs)
      if result[:success]
        puts 'Result: OK'
        self.ok_count += 1
      else
        puts 'Result: NG'
        self.ng_count += 1
        self.ng_paths.push(path)
      end
      puts result[:compare_message]

      result[:success]
    end

    def compare(nested_keys_each_env, envs)
      compare_message = ""

      if !(envs - nested_keys_each_env.keys).empty?
        compare_message += "There is no key:\n"
        compare_message += "  #{envs - nested_keys_each_env.keys}"
        return {
          success: false,
          compare_message: compare_message,
        }
      end

      first_env = envs.first
      other_envs = envs.drop(1)

      success = true
      other_envs.each do |other_env|
        if nested_keys_each_env[other_env] != nested_keys_each_env[first_env]
          success = false
          compare_message += "Diff:\n"

          diff_nested_keys = nested_keys_each_env[other_env] - nested_keys_each_env[first_env]
          if !diff_nested_keys.empty?
            compare_message += "  #{other_env} - #{first_env}:\n"
            diff_nested_keys.each do |diff_nested_key|
              compare_message += "    #{diff_nested_key.join('.')}\n"
            end
          end

          diff_nested_keys = nested_keys_each_env[first_env] - nested_keys_each_env[other_env]
          if !diff_nested_keys.empty?
            compare_message += "  #{first_env} - #{other_env}:\n"
            diff_nested_keys.each do |diff_nested_key|
              compare_message += "    #{diff_nested_key.join('.')}\n"
            end
          end
        end
      end

      {
        success: success,
        compare_message: compare_message,
      }
    end

    private

    def print_start_title
      puts "#################################"
      puts "#     YAML Structure Check      #"
      puts "#################################"
      puts "\n"
    end

    def print_result_title
      puts "#################################"
      puts "#  YAML Structure Check Result  #"
      puts "#################################"
      puts "\n"
    end

    def print_exclude_paths(exclude_paths)
      puts "Exclude paths:"
      if(exclude_paths.size == 0)
        puts "  nothing"
      end

      exclude_paths.each do |exclude_path|
        puts "  #{exclude_path}"
      end
      puts "\n"
    end

    def print_skip_paths(skip_paths)
      puts "Skip paths:"
      if(skip_paths.size == 0)
        puts "  nothing"
      end

      skip_paths.each do |skip_path|
        puts "  #{skip_path}"
      end
      puts "\n"
    end

    def print_ng_paths(ng_paths)
      puts "NG paths:"
      if(ng_paths.size == 0)
        puts "  nothing"
      end

      ng_paths.each do |ng_path|
        puts "  #{ng_path}"
      end
      puts "\n"
    end
  end
end
