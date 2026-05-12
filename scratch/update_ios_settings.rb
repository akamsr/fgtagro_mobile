require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

def configure_flavors(project, flavor)
  config_map = {
    'Debug' => "Debug-#{flavor}",
    'Release' => "Release-#{flavor}",
    'Profile' => "Profile-#{flavor}"
  }

  bundle_id = "com.example.fgtagroMobile#{flavor == 'dev' ? '.dev' : ''}"
  flutter_target = "lib/main_#{flavor}.dart"

  # Update project configurations
  project.build_configurations.each do |config|
    new_name = config_map[config.name]
    next if new_name.nil?
    
    # Find or create
    target_config = project.build_configurations.find { |c| c.name == new_name }
    if target_config
      puts "Updating project configuration #{new_name}..."
      target_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_id
      target_config.build_settings['FLUTTER_TARGET'] = flutter_target
      # Ensure app name is correct if needed, but usually handled via Info.plist
    end
  end

  # Update target configurations
  project.targets.each do |target|
    target.build_configurations.each do |config|
      new_name = config_map[config.name]
      next if new_name.nil?

      target_config = target.build_configurations.find { |c| c.name == new_name }
      if target_config
        puts "Updating target #{target.name} configuration #{new_name}..."
        if target.name == 'Runner'
          target_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_id
          target_config.build_settings['FLUTTER_TARGET'] = flutter_target
        end
      end
    end
  end
end

['dev', 'prod'].each do |flavor|
  configure_flavors(project, flavor)
end

project.save
puts "Successfully updated iOS flavor build settings (Bundle ID and Flutter Target)!"
