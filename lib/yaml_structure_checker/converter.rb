module YAMLStructureChecker
  class Converter
    # [example]
    # args:
    # hash = {
    #   'development' => { 'x' => 1, 'y' => 2, 'z' => 3 },
    #   'test' => {
    #     'p' => { 'q' => { 'r' => 4 } },
    #     's' => { 't' => { 'u' => 5 } },
    #   },
    #   'production' => 6,
    # }
    #
    # return:
    # [
    #   ['development', 'x'],
    #   ['development', 'y'],
    #   ['development', 'z'],
    #   ['test', 'p', 'q', 'r'],
    #   ['test', 's', 't', 'u'],
    #   ['production']
    # ]
    def self.hash_to_nested_keys(
      hash,
      nested_keys = [],
      key_ancestors = []
    )
      keys = hash.keys
      keys.each do |key|
        value = hash[key]
        child_key_ancestors = nested_key = key_ancestors.clone.push(key)
        if value.class == Hash
          hash_to_nested_keys(value, nested_keys, child_key_ancestors)
        else
          nested_keys.push(nested_key)
        end
      end

      nested_keys
    end

    # [example]
    # args:
    # nested_keys = [
    #   ['development', 'x'],
    #   ['development', 'y'],
    #   ['development', 'z'],
    #   ['test', 'p', 'q', 'r'],
    #   ['test', 's', 't', 'u'],
    #   ['production']
    # ]
    # envs = ['development', 'test', 'production']
    #
    # return:
    # {
    #   'development' => [['x'], ['y'], ['z']],
    #   'test' => [%w[p q r], %w[s t u]],
    #   'production' => [[]],
    # }
    def self.nested_keys_to_nested_keys_each_env(nested_keys, envs)
      nested_keys_each_env = {}
      envs.each do |env|
        nested_keys_each_env[env] = []
      end

      nested_keys.each do |nested_key|
        nested_key = nested_key.clone
        env = nested_key.first
        nested_key_without_env = nested_key.drop(1)

        if envs.include?(env)
          nested_keys_each_env[env].push(nested_key_without_env)
        end
      end

      nested_keys_each_env
    end
  end
end
