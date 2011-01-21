namespace(:test) do 
  namespace(:fixture_sets) do
    desc 'Scan for new fixture set specification and write out YAML fixtures'
    task 'scan' => :environment do
      FixtureSet.all_sets.each do |set|
        next if set.populated?
        puts "Generating YAML files for unpopulated Fixture Set '#{set.name}'"
        set.populate! do |table_name|
          puts "Generating fixture for tables '#{table_name}'"
        end
      end
    end
    
    desc 'Rebuild fixture sets by evaluating the specification and replacing the YAML files'
    task 'rebuild' => :environment do
      
    end
  end
end