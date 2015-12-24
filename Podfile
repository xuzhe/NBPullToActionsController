source 'https://github.com/CocoaPods/Specs.git'

# Uncomment this line to define a global platform for your project
platform :ios, "7.0"
inhibit_all_warnings!

pod 'Masonry'
pod 'THObserversAndBinders'
pod 'ALActionBlocks'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"	#fix the Too many arguments to function call, expected 0, have 2; Enable Strict Checking of objc_msgSend Problem
      #config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      #config.build_settings.delete(:ARCHS)
    end
  end
end
