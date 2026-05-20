require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

# Zixflow React Native wrapper podspec
# Uses Zixflow iOS SDK via CocoaPods
Pod::Spec.new do |s|
  s.name         = "zixflow-reactnative"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/zixflow/zixflow-reactnative.git", :tag => "#{s.version}" }

  s.source_files = "ios/wrappers/**/*.{h,m,mm,swift}"

  # Use install_modules_dependencies helper to install the dependencies if React Native version >=0.71.0.
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"
  end

  # Zixflow iOS SDK dependencies via CocoaPods
  # Using `= X.X.X` for exact version matching
  s.dependency "ZixflowDataPipelines", package["zixflowNativeiOSSdkVersion"]
  s.dependency "ZixflowMessagingInApp", package["zixflowNativeiOSSdkVersion"]
  s.dependency "ZixflowCommon", package["zixflowNativeiOSSdkVersion"]
  s.dependency "ZixflowTrackingMigration", package["zixflowNativeiOSSdkVersion"]

  # Transitive dependencies (required for explicit module builds)
  s.dependency "AnalyticsSwiftZixflow", "1.7.3+zixflow.1"
  s.dependency "JSONSafeEncoding", "~> 2.0"
  s.dependency "Sovran", "~> 1.1"
  s.dependency "LDSwiftEventSource", "~> 3.3"

  # If we do not specify a default_subspec, then *all* dependencies inside of *all* the subspecs will be downloaded by cocoapods.
  # We want customers to opt into push dependencies especially because the FCM subspec downloads Firebase dependencies. APN customers should not install Firebase dependencies at all.
  s.default_subspec = "nopush"

  s.subspec "nopush" do |ss|
    # This is the default subspec designed to not install any push dependencies. Customer should choose APN or FCM.
    # The SDK at runtime currently requires the MessagingPush module so we do include it here.
    ss.dependency "ZixflowMessagingPush", package["zixflowNativeiOSSdkVersion"]
  end

  # Note: Subspecs inherit all dependencies specified the parent spec (this file).
  s.subspec "apn" do |ss|
    ss.dependency "ZixflowMessagingPushAPN", package["zixflowNativeiOSSdkVersion"]
  end

  s.subspec "fcm" do |ss|
    ss.dependency "ZixflowMessagingPushFCM", package["zixflowNativeiOSSdkVersion"]
  end

  # Location module is optional - customers must opt in by adding this subspec.
  s.subspec "location" do |ss|
    ss.dependency "ZixflowLocation", package["zixflowNativeiOSSdkVersion"]
    ss.pod_target_xcconfig = {
      'OTHER_SWIFT_FLAGS' => '$(inherited) -DCIO_LOCATION_ENABLED'
    }
  end
end
