require 'spec_helper'

describe Constfig do
  before(:each) do
    Object.send :remove_const, :FOO if Object.const_defined?(:FOO)
    ENV.delete 'FOO'
  end

  it "should define config var from a default" do
    define_config :FOO, 123
    FOO.should == 123
  end

  it "should define config var from ENV" do
    ENV['FOO'] = '456'
    define_config :FOO
    FOO.should == '456'
  end

  it "should prefer ENV over default" do
    ENV['FOO'] = 'bar'
    define_config :FOO, 'baz'
    FOO.should == 'bar'
  end

  it "should raise exception when no default and no ENV" do
    ->{
      define_config :FOO
    }.should raise_error(/missing/)
  end

  it "should not change an already defined constant" do
    Object.const_set :FOO, 'foo'
    define_config :FOO, 'bar'
    FOO.should == 'foo'
  end

  describe :conversions do
    def self.verify_conversion(env, default, expected)
      it "should convert #{env.inspect}\tto\t#{expected.inspect}\twhen default is\t#{default.inspect}" do
        ENV['FOO'] = env
        define_config :FOO, default
        FOO.should == expected
      end
    end

    verify_conversion '12.3',  '456', '12.3'
    verify_conversion '12.3',  456,   12
    verify_conversion '12.3',  456.0, 12.3
    verify_conversion 'foo',   :bar,  :foo
    verify_conversion '0',     true,  false
    verify_conversion 'false', true,  false
    verify_conversion 'FALSE', true,  false
    verify_conversion 'foo',   true,  false
    verify_conversion '1',     true,  true
    verify_conversion 'true',  true,  true
    verify_conversion 'TRUE',  true,  true

    verify_conversion '12.3', Fixnum,     12
    verify_conversion '12.3', Float,      12.3
    verify_conversion '12.3', String,     '12.3'
    verify_conversion 'foo',  Symbol,     :foo
    verify_conversion 'foo',  TrueClass,  false
    verify_conversion 'foo',  FalseClass, false
    verify_conversion '0',    TrueClass,  false
    verify_conversion '0',    FalseClass, false
    verify_conversion '1',    TrueClass,  true
    verify_conversion '1',    FalseClass, true
    verify_conversion 'true', TrueClass,  true
    verify_conversion 'true', FalseClass, true
    verify_conversion 'TRUE', TrueClass,  true
    verify_conversion 'TRUE', FalseClass, true
  end

end
