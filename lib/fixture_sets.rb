module Test
  module Unit
    module FixtureSets
      # Load a fixture set by name.
      def fixture_set(name)
        fixture_set_path = FixtureSet.path_for_set(name)        
        raise "Unable to find Fixture Set named #{name} [#{fixture_set_path}]" unless File.exists?(fixture_set_path)        
        fixture_files = FixtureSet.fixtures_for_set(name)
        raise "No fixtures found in #{fixture_set_path}, have you run rake test:fixture_sets:scan?" if fixture_files.empty?
        @@original_fixture_path = Test::Unit::TestCase.fixture_path        
        Test::Unit::TestCase.fixture_path = fixture_set_path
        fixture_symbols = fixture_files.map {|f| f.gsub('.yml', '').to_sym}
        fixtures(*fixture_symbols)
      end
      
      def teardown_with_fixture_set
        Test::Unit::TestCase.fixture_path = @@original_fixture_path
      end
      alias_method :teardown, :teardown_with_fixture_set
    end
  end
end
