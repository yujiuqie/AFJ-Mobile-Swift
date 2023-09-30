source 'https://cdn.cocoapods.org/'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'AFJ-Mobile-Swift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AFJ-Mobile-Swift

  pod 'Alamofire'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SnapKit', '~> 5.6.0'
  
  target 'AFJ-Mobile-SwiftTests' do
    inherit! :search_paths
  end

  target 'AFJ-Mobile-SwiftUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
      end
    end
  end

end
