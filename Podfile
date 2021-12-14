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
  # Other
  pod 'R.swift'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'

  target 'KikurageTests' do
    inherit! :search_paths
  end

end

# 暫定：M1 Macのシミュレータ向けビルドを通す処理
post_install do | installer |
  installer.pods_project.targets.each do | target |
    target.build_configurations.each do | config |
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
