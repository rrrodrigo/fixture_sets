class TestGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, "#{class_name}Test"

      # Observer, and test directories.
      m.directory File.join('test/misc', class_path)

      # Observer class and unit test fixtures.
      m.template 'unit_test.rb',  File.join('test/misc', class_path, "#{file_name}_test.rb")
    end
  end
end
