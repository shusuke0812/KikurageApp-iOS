# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
use_frameworks!

def common_pods
  # Firebase
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseUI/Storage'
  pod 'FirebaseRemoteConfig'
  # UI
  pod 'Charts'
  pod 'IQKeyboardManagerSwift'
  pod 'PKHUD', '~> 5.0'
  pod 'HorizonCalendar'
  pod 'CropViewController'
  # Other
  pod 'RxSwift', '6.8.0'
  pod 'RxCocoa', '6.8.0'
  pod 'SDWebImage'
end

def resource_pods
  pod 'R.swift'
end

target 'Kikurage' do
  # Pods for kikurageApp
  common_pods
  resource_pods
  
  pod 'FirebaseCrashlytics'
  pod 'FirebaseAnalytics'
end

target 'KikurageFeature' do
  #inherit! :search_paths
  #common_podsは含めいないようにする（特にFirebaseを含めると`LoginHelper`で行うData型からUser型へのキャストができなくなる）
  pod 'konashi-ios-sdk'
end

target 'KikurageUI' do
  #inherit! :search_paths
  pod 'FontAwesome.swift'
  pod 'FirebaseUI/Storage'
  resource_pods
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
  installer.pods_project.targets.each do | target |
    target.build_configurations.each do | config |
      # 暫定：M1 Macのシミュレータ向けビルドを通す処理
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      # Xcode14.3.1にした時に出るToolchainsのエラーを消すための処理
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
    # Make it work with GoogleDataTransport
    if target.name.start_with? "GoogleDataTransport"
      target.build_configurations.each do |config|
        config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
      end
    end
  end
  # 設定アプリへの著作権情報書き出し（https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements）
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Kikurage/Pods-Kikurage-Acknowledgements.plist', 
    'Kikurage/Settings.bundle/Acknowledgements.plist', 
    :remove_destination => true)
end
