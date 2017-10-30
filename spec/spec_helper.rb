$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/filter'
require 'fluent/plugin/filter_object_flatten'
require 'time'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

def create_driver(options = {})
  fluentd_conf = <<-EOS
type object_flatten
  EOS

  if options[:separator]
    fluentd_conf << <<-EOS
separator #{options[:separator]}
    EOS
  end

  if options[:tr]
    fluentd_conf << <<-EOS
tr #{options[:tr].inspect}
    EOS
  end

  Fluent::Test::Driver::Filter.new(Fluent::Plugin::ObjectFlattenFilter).configure(fluentd_conf)
end

# prevent Test::Unit's AutoRunner from executing during RSpec's rake task
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)
