class FixtureSetGenerator < Rails::Generator::Base
  attr_reader :file_name
  
  def initialize(*runtime_args)
    super(*runtime_args)
    @file_name = args.first
    raise "Must specify a name for the Fixture Set" unless @file_name
    raise "'base' is a reserved name for Fixture Sets, please choose another name" if @file_name == 'base'
  end
  
  def manifest
    record do |m|
      m.directory File.join('test/fixture_sets', file_name)
      m.template 'fixture_set.rb',   File.join('test/fixture_sets', file_name, "#{file_name}_fixture_set.rb")
    end
  end
end
