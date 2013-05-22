require "constfig/version"
module Constfig
  class Undefined < RuntimeError; end
  module Config
    def define_config name, default = (no_default = true;nil)
      return if Object.const_defined?(name)

      has_default_value = !no_default # && default.class != Class

      if value = ENV[name.to_s]
        if has_default_value
          type = default.is_a?(Class) ? default.name : default.class.name
          value = convert_to_type value, type
        end
      else
        raise RuntimeError, "missing config #{name}, and no default was provided" unless has_default_value
        value = default
      end

      Object.const_set name, value
    end

    private

    def convert_to_type(value, type)
      case type
      when 'Fixnum'
        value.to_i
      when 'Float'
        value.to_f
      when 'Symbol'
        value.to_sym
      when 'TrueClass', 'FalseClass'
        '1' == value || 'true' == value || 'TRUE' == value
      else
        value
      end
    end
  end
end
