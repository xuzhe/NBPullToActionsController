# Uncomment this line to define a global platform for your project
platform :ios, "7.0"

pod 'Masonry'
pod 'THObserversAndBinders'
pod 'ALActionBlocks'

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      config.build_settings.delete(:ARCHS)
    end
  end
end
