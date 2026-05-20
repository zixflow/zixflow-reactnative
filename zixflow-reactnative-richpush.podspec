require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

# Used by customers to install native iOS dependencies inside their Notification Service Extension (NSE) target to setup rich push.
# Note: We need a unique podspec for rich push because the other podspecs in this project install too many dependencies that should not be installed inside of a NSE target. We need this podspec which installs minimal dependencies that are only included in the NSE target.
Pod::Spec.new do |s|
  s.name         = "zixflow-reactnative-richpush"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]
  s.platforms    = { :ios => min_ios_version_supported }

  s.source       = { :git => "https://github.com/zixflow/zixflow-reactnative.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # Note: Zixflow iOS SDK dependencies need to be added to NSE target via CocoaPods
  # Add these pods to your NotificationServiceExtension target in your Podfile:
  # pod "ZixflowMessagingPushAPN", "= 1.0.0" (or ZixflowMessagingPushFCM for FCM)
  # pod "ZixflowMessagingPush", "= 1.0.0"
  # pod "ZixflowDataPipelines", "= 1.0.0"
  # pod "ZixflowCommon", "= 1.0.0"

  # Subspecs allow customers to choose between multiple options of what type of version of this rich push package they would like to install.
  # Set default subspec to 'apn' to prevent both APN and FCM dependencies from being installed by default.
  #
  # To override the default subspec, specify the desired subspec in your Podfile. For example:
  # pod 'zixflow-reactnative-richpush/fcm'

  s.default_subspec = 'apn'

  s.subspec 'apn' do |ss|
    # ZixflowMessagingPushAPN linked via SPM
  end

  s.subspec 'fcm' do |ss|
    # ZixflowMessagingPushFCM linked via SPM
  end
end
