require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == 'Runner' }

script_name = 'Copy GoogleService-Info.plist'
script_content = <<-SCRIPT
case "${CONFIGURATION}" in
  *dev*)
    cp -r "${PROJECT_DIR}/config/dev/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
    ;;
  *prod*)
    cp -r "${PROJECT_DIR}/config/prod/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
    ;;
  *)
    # Default to prod or just skip
    cp -r "${PROJECT_DIR}/config/prod/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
    ;;
esac
SCRIPT

# Find or create the build phase
build_phase = target.shell_script_build_phases.find { |bp| bp.name == script_name }
if build_phase
  puts "Updating existing Run Script phase..."
  build_phase.shell_script = script_content
else
  puts "Creating new Run Script phase..."
  build_phase = target.new_shell_script_build_phase(script_name)
  build_phase.shell_script = script_content
  # Move it before the 'Compile Sources' phase if possible, but definitely before 'Copy Bundle Resources'
  # Standard practice: Put it early.
  target.build_phases.delete(build_phase)
  target.build_phases.insert(1, build_phase)
end

project.save
puts "Successfully added GoogleService-Info.plist copy script to Xcode!"
