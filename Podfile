# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'einkaufskorb' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  

  # Pods for einkaufskorb
  pod 'SwiftIcons', '~> 3.0'
  
  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore

  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Core'
end
post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
end
