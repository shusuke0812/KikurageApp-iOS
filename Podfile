# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
use_frameworks!

def common_pods
  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseUI/Storage'
  pod 'Firebase/RemoteConfig'
  # UI
  pod 'Charts'
  pod 'IQKeyboardManagerSwift'
  pod 'PKHUD'
  pod 'HorizonCalendar'
  pod 'FontAwesome.swift'
  pod 'CropViewController'
  # Other
  pod 'R.swift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SDWebImage'
end

target 'Kikurage' do
  # Pods for kikurageApp
  common_pods
  
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
end

target 'KikurageFeature' do
  #inherit! :search_paths
  #common_podsは含めいないようにする（特にFirebaseを含めると`LoginHelper`で行うData型からUser型へのキャストができなくなる）
  pod 'konashi-ios-sdk'
end

target 'KikurageTests' do
  #inherit! :search_paths
  common_pods
end

target 'KikurageUITests' do
  #inherit! :search_paths
  common_pods
end

post_install do | installer |
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
  # Acknowledgment into Setting app（https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements）
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Kikurage/Pods-Kikurage-Acknowledgements.plist', 
    'Kikurage/Settings.bundle/Acknowledgements.plist', 
    :remove_destination => true)
end
