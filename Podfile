# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Notes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Notes
 pod 'SnapKit'

  target 'NotesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NotesUITests' do
    # Pods for testing
  end

end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
        end
    end
end