# Fixture sets 
class FixtureSet
  attr_reader :name
  attr_reader :path
  
  def self.define(name, &block)
    raise "You must pass a block to define a new Fixture Set" unless block_given?
    FixtureSet.new(:name => name, :path => path_for_set(name), :block => block)
  end
  
  def self.base_path
    File.join(RAILS_ROOT, 'test', 'fixture_sets')
  end
  
  def self.path_for_set(name)
    if name.to_sym == :base
      return File.expand_path(File.join(RAILS_ROOT, 'test', 'fixtures'))
    else
      return File.expand_path(File.join(RAILS_ROOT, 'test', 'fixture_sets', name.to_s))
    end
  end
  
  def self.fixtures_for_set(name)
    path = path_for_set(name)
    raise "No Fixture Set found with name '#{name}'" unless File.exists?(path)
    Dir.entries(path).reject {|e| e =~ /^\./ || e !~ /\.yml$/}
  end
  
  def self.load(name)
    eval(File.read(File.join(FixtureSet.path_for_set(name), "#{name}_fixture_set.rb")))
  end
  
  def self.all_sets
    fixture_sets = []
    Dir.entries(base_path).reject {|e| e =~ /^\./ || !File.directory?(File.join(base_path, e))}.each do |name|      
      fixture_sets << load(name)
    end
    fixture_sets
  end
  
  def initialize(attributes = {})
    @tables = {}
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
  
  def fixtures
    FixtureSet.fixtures_for_set(name)
  end
  
  def populated?
    !fixtures.empty?
  end
  
  def populate!(&block)
    @block.call(self)
    # Write out the YAML fixtures
    @tables.each do |table_name, data|
      yield table_name if block_given?
      File.open(File.join(path, "#{table_name}.yml"), 'w') do |f|
        f << data.inject({}) { |hsh, record| 
               hsh.merge("record_#{record.id}" => record.attributes) 
             }.to_yaml
      end
    end
    @tables = {}
    true
  end
    
  def method_missing(method, *args)
    table_name = method.to_s.chop
    raise "Table #{method} can only be defined once, aborting..." if @tables[table_name]
    @tables[table_name] = [args.first].flatten
  end
end