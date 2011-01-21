require File.join(File.dirname(__FILE__), "lib", "fixture_sets")
require File.join(File.dirname(__FILE__), "lib", "fixture_set")
if RAILS_ENV == 'test'
  require 'test/unit'
  Test::Unit::TestCase.send(:extend, Test::Unit::FixtureSets)
end
