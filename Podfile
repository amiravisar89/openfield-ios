# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

$minVersion = '15.0'

target 'Openfield' do
  
  platform :ios, $minVersion

  # Pods for Openfield

  # Architecture
  pod 'ReactorKit', '2.0.1'
  pod 'RxFlow', '2.6.0'
  
  # Rx
  $Rx = '5.1.1'
  pod 'RxSwift', $Rx
  pod 'RxCocoa', $Rx
  pod 'RxBlocking', $Rx
  pod 'RxSwiftExt', '5.1.1'
  pod 'RxViewController', '1.0.0'
  pod 'RxDataSources', '4.0.1'
  pod 'RxGesture', '3.0.2'
  pod 'RxViewController', '1.0.0'
  pod 'RxKingfisher', '1.0.0'

  # Tools
  pod 'R.swift', '7.3.0'
  pod 'Dollar', '9.0.0'
  pod 'SwiftyGif', '5.4.3'
  pod 'SwiftDate', '6.3.1'
  pod 'PhoneNumberKit', '3.3.4'
  pod 'EasyTipView', '2.1.0'
  pod 'SwiftyUserDefaults', '5.3.0'
  pod 'ReachabilitySwift', '5.0.0'
  pod 'NVActivityIndicatorView', '5.1.1'
  pod 'BetterSegmentedControl', '2.0.1'
  pod 'Smartlook', '1.7.1'
  pod 'Then', '2.7.0'
  pod 'Fakery', '5.1.0'

  
  # Firebase
  $FB = '11.2.0'
  pod 'Firebase/CoreOnly', $FB
  pod 'Firebase/Firestore', $FB
  pod 'Firebase/Auth', $FB
  pod 'Firebase/Analytics', $FB
  pod 'Firebase/Performance', $FB
  pod 'Firebase/RemoteConfig', $FB
  pod 'Firebase/DynamicLinks', $FB
  pod 'Firebase/Crashlytics', $FB
  pod 'Firebase/InAppMessaging', $FB
  pod 'Firebase/Messaging', $FB
  pod 'CodableFirebase', '0.2.1'

  
  # DI
  pod 'Resolver', '1.0.7'
  
  # UI
  pod 'PullUpController', '0.8.0' 
  pod 'SnapKit', '5.0.1' 
  pod 'TagListView', '1.4.1' 
  pod 'STPopup', '1.8.7' 
  pod 'FSPagerView', '0.8.3' 
  pod 'CollectionKit', '2.4.0' 
  pod 'UIView-Shimmer', '1.0.4'
  
  # Networking
  pod 'Alamofire', '5.0.0-rc.3'
  pod 'Moya', '14.0.0-beta.5'
  pod 'Moya/RxSwift'
  pod 'Kingfisher', '5.15.8' 
  pod 'KingfisherWebP', '1.1.0'
  pod 'GEOSwift', '10.1.0'
  
  # Logging
  pod 'CocoaLumberjack/Swift', '3.7.4'
  pod 'DatadogLogs', '2.19.0'
  pod 'DatadogCore', '2.19.0'

  # Rating
  pod 'Cosmos', '23.0.0' 
  
  #localize
  pod 'Lokalise', '0.10.2' 
  
  # Analytics
  pod 'Umbrella', '0.12.0'
  
  # Format & Lint
  pod 'SwiftFormat/CLI', '0.52.10'
  
  # Feature Flags
  pod 'LaunchDarkly', '9.8'

  target 'OpenfieldTests' do
    inherit! :search_paths
    
    platform :ios, $minVersion
    # Pods for testing
    pod 'Nimble', '13.1.2'
    pod 'Quick', '7.3.0'
    pod 'Cuckoo', '1.10.4'

  end


  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |configuration|
        target.build_settings(configuration.name)['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end

    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings["DEVELOPMENT_TEAM"] = "F4Y5835AFN"
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
           end
      end
    end
  end

end

