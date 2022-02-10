# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Kikurage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for kikurageApp
  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/RemoteConfig'
  pod 'FirebaseFirestoreSwift', '~> 0.2'
  pod 'FirebaseUI/Storage', '~> 8.0'
  # UI
  pod 'Charts'
  pod 'IQKeyboardManagerSwift'
  pod 'PKHUD', '~> 5.0'
  pod 'HorizonCalendar'
  pod 'FontAwesome.swift'
  pod 'CropViewController'
  # Other
  pod 'R.swift'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'

  target 'KikurageTests' do
    inherit! :search_paths
  end
  
  target 'KikurageUITests' do
    inherit! :search_paths
  end

  target 'KikurageFeature' do
    inherit! :search_paths
  end

end

post_install do | installer |
  # 暫定：M1 Macのシミュレータ向けビルドを通す処理
  installer.pods_project.targets.each do | target |
    target.build_configurations.each do | config |
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
  # 設定アプリへの著作権情報書き出し（https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements）
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Kikurage/Pods-Kikurage-Acknowledgements.plist', 
    'Kikurage/Settings.bundle/Acknowledgements.plist', 
    :remove_destination => true)
end
