module Puppet::Parser::Functions
  newfunction(:prefix_user_resources, :type => :rvalue, :doc => <<-EOS
This functions prefixes every key of a hash with the given string

*Examples*:

    prefix_user_resources({'a': {'x': 'y'}, 'b': {'x': 'z'}}, 'p_')

Would result in:

  {
    'p_a': {
      'x': 'y',
      'resource_name': 'a',
    },
    'p_b': {
      'x': 'z',
      'resource_name': 'b',
    }
  }
EOS
  ) do |arguments|

    # Validate number of arguments
    if arguments.size != 2
      raise(Puppet::ParseError, "prefix_user_resources(): Takes exactly two " +
            "arguments, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    if not hash.is_a?(Hash)
      raise(TypeError, "prefix_user_resources(): The first argument must be a " +
            "hash, but a #{hash.class} was given.")
    end

    # Validate the second argument.
    prefix = arguments[1]
    if not prefix.is_a?(String)
      raise(TypeError, "prefix_user_resources(): The second argument must be a " +
            "string, but a #{prefix.class} was given.")
    end

    result = hash.map do |k, v|
      {prefix + String(k) => v.is_a?(Hash) ? v.merge({:resource_name => k}) : v}
    end

    Hash[result]

  end
end

# vim: set ts=2 sw=2 et :
