module Puppet::Parser::Functions
  newfunction(:prefix_keys, :type => :rvalue, :doc => <<-EOS
This functions prefixes every key of a hash with the given string

*Examples*:

    prefix_keys({'a': 1, 'b': 2}, 'p_')

Would result in: {'p_a': 1, 'p_b': 2}
    EOS
  ) do |arguments|

    # Validate number of arguments
    if arguments.size != 2
      raise(Puppet::ParseError, "prefix_keys(): Takes exactly two " +
            "arguments, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    if not hash.is_a?(Hash)
      raise(TypeError, "prefix_keys(): The first argument must be a " +
            "hash, but a #{hash.class} was given.")
    end

    # Validate the second argument.
    prefix = arguments[1]
    if not prefix.is_a?(String)
      raise(TypeError, "prefix_values(): The second argument must be a " +
            "string, but a #{prefix.class} was given.")
    end

    result = hash.map do |k, v|
      prefix + String(k) => v
    end

    Hash[result]
  
  end
end

# vim: set ts=2 sw=2 et :
