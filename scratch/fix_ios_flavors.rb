2require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

def duplicate_configurations(project, flavor)
  config_map = {
    'Debug' => "Debug-#{flavor}",
    'Release' => "Release-#{flavor}",
    'Profile' => "Profile-#{flavor}"
  }

  # First, add to project
  project.build_configurations.each do |config|
    new_name = config_map[config.name]
    next if new_name.nil?
    next if project.build_configurations.any? { |c| c.name == new_name }

    puts "Creating project configuration #{new_name}..."
    new_config = project.add_build_configuration(new_name, config.type)
    new_config.build_settings = config.build_settings.dup
    new_config.base_configuration_reference = config.base_configuration_reference
  end

  # Then, add to targets
  project.targets.each do |target|
    config_map.each do |old_name, new_name|
      next if target.build_configurations.any? { |c| c.name == new_name }
      
      old_config = target.build_configurations.find { |c| c.name == old_name }
      next if old_config.nil?

      puts "Creating configuration #{new_name} for target #{target.name}..."
      
      new_config = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
      new_config.name = new_name
      new_config.build_settings = old_config.build_settings.dup
      new_config.base_configuration_reference = old_config.base_configuration_reference
      
      target.build_configuration_list.build_configurations << new_config
    end
  end
end

def create_scheme(project, flavor)
  scheme_name = flavor
  puts "Creating scheme #{scheme_name}..."
  
  scheme = Xcodeproj::XCScheme.new
  target = project.targets.find { |t| t.name == 'Runner' }
  
  scheme.add_build_target(target)
  scheme.launch_action.build_configuration = "Debug-#{flavor}"
  scheme.test_action.build_configuration = "Debug-#{flavor}"
  scheme.profile_action.build_configuration = "Profile-#{flavor}"
  scheme.analyze_action.build_configuration = "Debug-#{flavor}"
  scheme.archive_action.build_configuration = "Release-#{flavor}"
  
  # Correct way to set the runnable target in XCScheme
  scheme.launch_action.buildable_product_runnable = Xcodeproj::XCScheme::BuildableProductRunnable.new(target)
  
  scheme.save_as(project.path, scheme_name)
end

['dev', 'prod'].each do |flavor|
  duplicate_configurations(project, flavor)
  create_scheme(project, flavor)
end

project.save
puts "Successfully configured iOS flavors!"
