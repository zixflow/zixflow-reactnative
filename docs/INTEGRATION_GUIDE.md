# Zixflow React Native SDK - Integration Guide

Welcome to the **Zixflow React Native SDK** integration guide. This comprehensive document will help you install, configure, and use the Zixflow SDK in your React Native application to track user behavior, send push notifications, display in-app messages, and more.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
   - [npm Installation](#npm-installation)
   - [Yarn Installation](#yarn-installation)
4. [iOS Setup](#ios-setup)
   - [CocoaPods Integration](#cocoapods-integration)
   - [Swift Package Manager Integration](#swift-package-manager-integration)
   - [Push Notification Setup (APNs)](#push-notification-setup-apns)
   - [Notification Service Extension](#notification-service-extension)
5. [Android Setup](#android-setup)
   - [Gradle Configuration](#gradle-configuration)
   - [Firebase Cloud Messaging Setup](#firebase-cloud-messaging-setup)
6. [Quick Start](#quick-start)
   - [Basic Configuration](#basic-configuration)
   - [SDK Initialization](#sdk-initialization)
7. [Core Features](#core-features)
   - [User Identification](#user-identification)
   - [Event Tracking](#event-tracking)
   - [Screen Tracking](#screen-tracking)
   - [User Profile Attributes](#user-profile-attributes)
   - [Device Attributes](#device-attributes)
   - [Clearing User Identity](#clearing-user-identity)
8. [Push Notifications](#push-notifications)
   - [Requesting Permission](#requesting-permission)
   - [Handling Push Notifications](#handling-push-notifications)
   - [Device Token Registration](#device-token-registration)
9. [In-App Messaging](#in-app-messaging)
   - [Event Listeners](#event-listeners)
   - [Message Events](#message-events)
   - [Dismissing Messages](#dismissing-messages)
10. [Location Tracking](#location-tracking)
11. [Advanced Configuration](#advanced-configuration)
    - [Region Settings](#region-settings)
    - [Log Levels](#log-levels)
    - [Auto-Tracking Options](#auto-tracking-options)
    - [Custom API Hosts](#custom-api-hosts)
12. [Troubleshooting](#troubleshooting)
    - [Installation Issues](#installation-issues)
    - [iOS Build Errors](#ios-build-errors)
    - [Android Build Errors](#android-build-errors)
    - [Push Notification Issues](#push-notification-issues)
    - [In-App Message Issues](#in-app-message-issues)
13. [Example Applications](#example-applications)
14. [API Reference](#api-reference)
15. [Support & Resources](#support--resources)

---

## Introduction

The **Zixflow React Native SDK** enables you to:

- **Identify users** and track their behavior across your app
- **Send targeted push notifications** via Apple Push Notification service (APNs) or Firebase Cloud Messaging (FCM)
- **Display in-app messages** to engage users at the right time
- **Track user location** to enable location-based messaging
- **Manage user profiles** with custom attributes
- **Track events and screen views** automatically or manually

The SDK is built on top of the native Zixflow iOS and Android SDKs, providing a unified TypeScript API for React Native applications.

---

## Requirements

### React Native

- **React Native**: 0.60.0 or higher
- **React**: 16.8.0 or higher (for hooks support)

### iOS

- **iOS**: 13.0 or higher
- **Xcode**: 14.0 or higher
- **Swift**: 5.3 or higher
- **CocoaPods**: 1.10.0 or higher (if using CocoaPods)

### Android

- **Android**: API level 24 (Android 7.0) or higher
- **Kotlin**: 1.6.0 or higher
- **Gradle**: 7.0 or higher

### TypeScript (Recommended)

- **TypeScript**: 4.0 or higher

---

## Installation

### npm Installation

Install the SDK using npm:

```bash
npm install zixflow-reactnative
```

### Yarn Installation

Or install using Yarn:

```bash
yarn add zixflow-reactnative
```

After installation, proceed with platform-specific setup for iOS and Android.

---

## iOS Setup

### CocoaPods Integration

The Zixflow React Native SDK automatically integrates with the native iOS SDK via CocoaPods or Swift Package Manager. If you're using **React Native 0.60 or higher**, dependencies are auto-linked.

1. **Navigate to the iOS directory**:

```bash
cd ios
```

2. **Install CocoaPods dependencies**:

```bash
pod install
```

3. **Open the workspace in Xcode**:

```bash
open YourApp.xcworkspace
```

The SDK will automatically include the necessary Zixflow iOS modules:
- `ZixflowCommon`
- `ZixflowDataPipelines`
- `ZixflowMessagingPush`
- `ZixflowMessagingPushAPN` (for APNs)
- `ZixflowMessagingInApp`

### Swift Package Manager Integration

If you prefer **Swift Package Manager (SPM)**, you can configure your project to use the Zixflow iOS SDK directly:

1. **Open your project in Xcode**
2. **Go to File > Add Package Dependencies**
3. **Enter the repository URL**:
   ```
   https://github.com/zixflow/zixflow-ios.git
   ```
4. **Select the version**: Use `1.0.0` or higher
5. **Add the following modules** to your app target:
   - `Zixflow` (umbrella module)
   - `ZixflowDataPipelines`
   - `ZixflowMessagingPushAPN`
   - `ZixflowMessagingInApp`

> **Note**: The example app uses SPM for the native iOS SDK integration. See `example/ios/Podfile` for reference.

### Push Notification Setup (APNs)

To enable **Apple Push Notifications (APNs)**:

1. **Enable Push Notifications capability** in Xcode:
   - Select your app target
   - Go to **Signing & Capabilities**
   - Click **+ Capability** and add **Push Notifications**

2. **Enable Background Modes**:
   - Add **Background Modes** capability
   - Enable **Remote notifications**

3. **Configure APNs certificates** in your Apple Developer account and upload them to Zixflow dashboard.

### Notification Service Extension

To support **rich push notifications** (images, videos, action buttons), you need to add a **Notification Service Extension**:

1. **Create a Notification Service Extension** in Xcode:
   - File > New > Target > Notification Service Extension
   - Name it `NotificationServiceExtension`

2. **Add Zixflow modules to the extension** in your `Podfile`:

```ruby
target 'NotificationServiceExtension' do
  pod "ZixflowMessagingPushAPN", "~> 1.0"
  pod "ZixflowMessagingPush", "~> 1.0"
  pod "ZixflowDataPipelines", "~> 1.0"
  pod "ZixflowCommon", "~> 1.0"
  pod "ZixflowTrackingMigration", "~> 1.0"
  pod "AnalyticsSwiftZixflow", "1.7.3+zixflow.1"
end
```

3. **Update `NotificationService.swift`**:

```swift
import UserNotifications
import ZixflowMessagingPushAPN

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        // Use Zixflow to handle rich push
        MessagingPushAPN.didReceive(request, withContentHandler: contentHandler)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
```

4. **Run `pod install`** again to install extension dependencies.

---

## Android Setup

### Gradle Configuration

The React Native auto-linking will handle most of the Android setup. However, you need to ensure the following:

1. **Set minimum SDK version** in `android/build.gradle`:

```gradle
buildscript {
    ext {
        minSdkVersion = 24
        compileSdkVersion = 34
        targetSdkVersion = 34
    }
}
```

2. **Add Maven repositories** in `android/build.gradle`:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://s01.oss.sonatype.org/content/repositories/snapshots/' }
    }
}
```

The Zixflow Android SDK will be automatically included via the React Native module.

### Firebase Cloud Messaging Setup

To enable **Firebase Cloud Messaging (FCM)** for push notifications on Android:

1. **Add Firebase to your project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Add your Android app
   - Download `google-services.json` and place it in `android/app/`

2. **Add Google Services plugin** in `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

3. **Apply the plugin** in `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

4. **Configure FCM in the SDK** (shown in the initialization section below).

---

## Quick Start

### Basic Configuration

The SDK is configured using a `CioConfig` object with several options:

```typescript
import { Zixflow, CioConfig, Region, CioLogLevel } from 'zixflow-reactnative';

const config: CioConfig = {
  cdpApiKey: 'YOUR_CDP_API_KEY',
  region: Region.US,
  logLevel: CioLogLevel.debug,
  inAppConfig: {
    siteId: 'YOUR_SITE_ID',
  },
  autoTrackDeviceAttributes: true,
  trackApplicationLifecycleEvents: true,
};
```

**Configuration Options**:

| Option | Type | Required | Description |
|--------|------|----------|-------------|
| `cdpApiKey` | string | Yes | Your Zixflow CDP API key |
| `region` | `Region` | No | Data center region (US, EU) |
| `logLevel` | `CioLogLevel` | No | Logging level (debug, info, error, none) |
| `inAppConfig` | object | No | In-app messaging configuration |
| `inAppConfig.siteId` | string | Yes* | Site ID for in-app messaging |
| `autoTrackDeviceAttributes` | boolean | No | Automatically track device info |
| `trackApplicationLifecycleEvents` | boolean | No | Automatically track app lifecycle |

### SDK Initialization

Initialize the SDK in your `App.tsx` or main component using `useEffect`:

```typescript
import React, { useEffect } from 'react';
import { Zixflow, CioConfig, Region, CioLogLevel } from 'zixflow-reactnative';

export default function App() {
  useEffect(() => {
    // Configure the SDK
    const config: CioConfig = {
      cdpApiKey: 'YOUR_CDP_API_KEY',
      region: Region.US,
      logLevel: CioLogLevel.debug,
      inAppConfig: {
        siteId: 'YOUR_SITE_ID',
      },
      autoTrackDeviceAttributes: true,
      trackApplicationLifecycleEvents: true,
    };

    // Initialize the SDK
    Zixflow.initialize(config);

    console.log('Zixflow SDK initialized');
  }, []);

  return (
    // Your app UI
  );
}
```

> **Important**: Initialize the SDK as early as possible in your app's lifecycle, ideally in the root component's `useEffect`.

---

## Core Features

### User Identification

Identify users to track their behavior across sessions and devices:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Identify user with ID only
Zixflow.identify({
  userId: 'user-123'
});

// Identify user with traits
Zixflow.identify({
  userId: 'user-123',
  traits: {
    email: 'user@example.com',
    firstName: 'John',
    lastName: 'Doe',
    plan: 'premium'
  }
});
```

**When to identify users**:
- After successful login
- When user information becomes available
- After account creation

### Event Tracking

Track custom events to understand user behavior:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Track event without properties
Zixflow.track('button_clicked');

// Track event with properties
Zixflow.track('product_viewed', {
  product_id: '12345',
  product_name: 'Premium Plan',
  category: 'subscription',
  price: 29.99
});

// Track with Map (alternative syntax)
const properties = new Map<string, any>();
properties.set('item_count', 3);
properties.set('total_amount', 89.97);
Zixflow.track('checkout_completed', properties);
```

**Common events to track**:
- User actions (button clicks, form submissions)
- E-commerce events (product views, purchases)
- Content interactions (article reads, video plays)
- Feature usage

### Screen Tracking

Track screen views to understand user navigation:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Track screen view
Zixflow.screen('HomeScreen');

// Track screen with properties
Zixflow.screen('ProductDetailScreen', {
  product_id: '12345',
  category: 'electronics'
});
```

**Automatic screen tracking** with React Navigation:

```typescript
import { NavigationContainer, NavigationContainerRef } from '@react-navigation/native';
import { Zixflow } from 'zixflow-reactnative';
import React, { useRef } from 'react';

export default function App() {
  const navigationRef = useRef<NavigationContainerRef>(null);
  const routeNameRef = useRef<string>();

  return (
    <NavigationContainer
      ref={navigationRef}
      onReady={() => {
        routeNameRef.current = navigationRef.current?.getCurrentRoute()?.name;
      }}
      onStateChange={async () => {
        const previousRouteName = routeNameRef.current;
        const currentRouteName = navigationRef.current?.getCurrentRoute()?.name;

        if (previousRouteName !== currentRouteName && currentRouteName) {
          // Track screen change
          Zixflow.screen(currentRouteName);
        }

        // Save current route name
        routeNameRef.current = currentRouteName;
      }}
    >
      {/* Your navigation setup */}
    </NavigationContainer>
  );
}
```

### User Profile Attributes

Set custom attributes on user profiles:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Set profile attributes
Zixflow.setProfileAttributes({
  plan: 'premium',
  subscription_status: 'active',
  last_login: new Date().toISOString(),
  preferences: {
    newsletter: true,
    notifications: true
  }
});
```

### Device Attributes

Set custom attributes on the current device:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Set device attributes
Zixflow.setDeviceAttributes({
  app_version: '2.1.0',
  build_number: '421',
  theme: 'dark',
  language_preference: 'en-US'
});
```

### Clearing User Identity

Clear user identity when users log out:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Clear identify on logout
const handleLogout = async () => {
  // Clear Zixflow identity
  Zixflow.clearIdentify();

  // Perform other logout actions
  // ...
};
```

---

## Push Notifications

### Requesting Permission

Request push notification permission from the user:

```typescript
import { Zixflow, CioPushPermissionStatus } from 'zixflow-reactnative';

const requestPushPermission = async () => {
  const permission = await Zixflow.pushMessaging.showPromptForPushNotifications({
    ios: {
      sound: true,
      badge: true,
      alert: true
    }
  });

  switch (permission) {
    case CioPushPermissionStatus.Granted:
      console.log('Push notifications enabled');
      break;
    case CioPushPermissionStatus.Denied:
      console.log('Push notifications denied');
      break;
    case CioPushPermissionStatus.NotDetermined:
      console.log('Push notification permission not determined');
      break;
  }

  return permission;
};
```

**Permission options (iOS)**:
- `sound`: Enable notification sounds
- `badge`: Enable app badge updates
- `alert`: Show notification alerts

### Handling Push Notifications

The SDK automatically handles push notifications. To track when notifications are received or opened:

```typescript
import { Zixflow } from 'zixflow-reactnative';
import { useEffect } from 'react';

useEffect(() => {
  // Track notification received
  Zixflow.track('push_notification_received', {
    timestamp: new Date().toISOString()
  });
}, []);
```

### Device Token Registration

The SDK automatically registers device tokens for push notifications after permission is granted. You don't need to handle this manually.

---

## In-App Messaging

### Event Listeners

Register event listeners to respond to in-app message events:

```typescript
import { Zixflow, InAppMessageEvent, InAppMessageEventType } from 'zixflow-reactnative';
import { useEffect } from 'react';

export default function App() {
  useEffect(() => {
    const inAppMessaging = Zixflow.inAppMessaging;

    const eventListener = inAppMessaging.registerEventsListener((event: InAppMessageEvent) => {
      switch (event.eventType) {
        case InAppMessageEventType.messageShown:
          console.log('In-app message shown', event);
          break;

        case InAppMessageEventType.messageDismissed:
          console.log('In-app message dismissed', event);
          break;

        case InAppMessageEventType.messageActionTaken:
          console.log('Action taken on in-app message', event);
          handleMessageAction(event);
          break;

        case InAppMessageEventType.errorWithMessage:
          console.error('Error with in-app message', event);
          break;
      }
    });

    // Cleanup listener on unmount
    return () => {
      eventListener.remove();
    };
  }, []);

  return (
    // Your app UI
  );
}
```

### Message Events

The SDK provides the following in-app message event types:

| Event Type | Description |
|------------|-------------|
| `messageShown` | Message was displayed to the user |
| `messageDismissed` | Message was dismissed by the user |
| `messageActionTaken` | User took an action on the message (clicked button, link, etc.) |
| `errorWithMessage` | Error occurred while displaying the message |

**Event properties**:
- `eventType`: The type of event
- `deliveryId`: Unique delivery identifier
- `messageId`: Message template identifier
- `actionName`: Name of the action taken (for `messageActionTaken`)
- `actionValue`: Value of the action (for `messageActionTaken`)

### Dismissing Messages

Programmatically dismiss the current in-app message:

```typescript
import { Zixflow } from 'zixflow-reactnative';

const handleMessageAction = (event: InAppMessageEvent) => {
  if (event.actionValue === 'dismiss' || event.actionValue === 'close') {
    // Dismiss the message
    Zixflow.inAppMessaging.dismissMessage();
  }
};
```

---

## Location Tracking

Enable location tracking to send location-based messages:

```typescript
import { Zixflow } from 'zixflow-reactnative';

// Location tracking is configured via the native SDK
// Make sure to request location permissions in your app

// iOS: Add location permission keys to Info.plist
// - NSLocationWhenInUseUsageDescription
// - NSLocationAlwaysAndWhenInUseUsageDescription

// Android: Add location permissions to AndroidManifest.xml
// - ACCESS_FINE_LOCATION
// - ACCESS_COARSE_LOCATION
```

Request location permissions using a library like `react-native-permissions`:

```typescript
import { request, PERMISSIONS, RESULTS } from 'react-native-permissions';
import { Platform } from 'react-native';

const requestLocationPermission = async () => {
  const permission = Platform.select({
    ios: PERMISSIONS.IOS.LOCATION_WHEN_IN_USE,
    android: PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
  });

  if (!permission) return;

  const result = await request(permission);

  if (result === RESULTS.GRANTED) {
    console.log('Location permission granted');
  }
};
```

---

## Advanced Configuration

### Region Settings

Configure the data center region for data residency:

```typescript
import { Zixflow, Region } from 'zixflow-reactnative';

const config = {
  cdpApiKey: 'YOUR_API_KEY',
  region: Region.US,  // or Region.EU
};

Zixflow.initialize(config);
```

**Available regions**:
- `Region.US` - United States data center
- `Region.EU` - European Union data center

### Log Levels

Control SDK logging for debugging:

```typescript
import { Zixflow, CioLogLevel } from 'zixflow-reactnative';

const config = {
  cdpApiKey: 'YOUR_API_KEY',
  logLevel: CioLogLevel.debug,  // debug, info, error, none
};

Zixflow.initialize(config);
```

**Log levels**:
- `CioLogLevel.debug` - Verbose logging (development)
- `CioLogLevel.info` - Informational messages
- `CioLogLevel.error` - Errors only
- `CioLogLevel.none` - No logging (production)

### Auto-Tracking Options

Configure automatic tracking features:

```typescript
import { Zixflow } from 'zixflow-reactnative';

const config = {
  cdpApiKey: 'YOUR_API_KEY',

  // Automatically track device attributes (OS, model, app version)
  autoTrackDeviceAttributes: true,

  // Automatically track app lifecycle events (open, close, background)
  trackApplicationLifecycleEvents: true,

  // Automatically track screens (requires integration)
  autoTrackScreenViews: true,
};

Zixflow.initialize(config);
```

### Custom API Hosts

Override API endpoints for testing or custom infrastructure:

```typescript
import { Zixflow } from 'zixflow-reactnative';

const config = {
  cdpApiKey: 'YOUR_API_KEY',

  // Custom tracking API host
  trackingApiUrl: 'https://custom-track.zixflow.com',

  // Custom in-app messaging API host
  inAppConfig: {
    siteId: 'YOUR_SITE_ID',
    // Override in-app messaging API endpoint if needed
  },
};

Zixflow.initialize(config);
```

---

## Troubleshooting

### Installation Issues

**Issue**: `npm install` fails with dependency conflicts

**Solution**: Use `--legacy-peer-deps` flag:
```bash
npm install zixflow-reactnative --legacy-peer-deps
```

Or with Yarn:
```bash
yarn add zixflow-reactnative --legacy-peer-deps
```

---

**Issue**: Auto-linking fails after installation

**Solution**: Try manual linking:

1. Clean the build:
```bash
cd android && ./gradlew clean && cd ..
cd ios && rm -rf Pods && pod install && cd ..
```

2. Rebuild the app:
```bash
npx react-native run-ios
npx react-native run-android
```

### iOS Build Errors

**Issue**: `Module 'Zixflow' not found`

**Solution**:
1. Ensure you've run `pod install` in the `ios` directory
2. Clean build folder in Xcode: Product > Clean Build Folder
3. Rebuild the project

---

**Issue**: Swift compiler errors in native modules

**Solution**:
1. Check Xcode version (14.0+ required)
2. Update CocoaPods: `sudo gem install cocoapods`
3. Update pod dependencies: `cd ios && pod update && cd ..`

---

**Issue**: Notification Service Extension not working

**Solution**:
1. Ensure the extension target has the correct dependencies in Podfile
2. Run `pod install` after adding the extension
3. Check that the extension's deployment target is iOS 13.0+
4. Verify the extension is added to your app's target dependencies

### Android Build Errors

**Issue**: `Cannot find symbol class Zixflow`

**Solution**:
1. Clean Gradle cache:
```bash
cd android && ./gradlew clean && cd ..
```

2. Rebuild the app:
```bash
npx react-native run-android
```

---

**Issue**: Duplicate class errors with Firebase

**Solution**:
1. Check that you're not including Firebase dependencies manually if using FCM
2. Ensure all Firebase dependencies use the same version
3. Add to `android/gradle.properties`:
```properties
android.enableJetifier=true
```

---

**Issue**: Minimum SDK version error

**Solution**: Update `android/build.gradle`:
```gradle
ext {
    minSdkVersion = 24
}
```

### Push Notification Issues

**Issue**: Push notifications not received on iOS

**Checklist**:
- [ ] Push Notifications capability enabled in Xcode
- [ ] APNs certificate uploaded to Zixflow dashboard
- [ ] Device token registered (check logs)
- [ ] Permission granted by user
- [ ] App not in foreground (notifications shown in background/killed state)

---

**Issue**: Push notifications not received on Android

**Checklist**:
- [ ] `google-services.json` file added to `android/app/`
- [ ] Google Services plugin applied in `android/app/build.gradle`
- [ ] FCM server key uploaded to Zixflow dashboard
- [ ] Device registered for push (check logs)
- [ ] Notification permissions granted (Android 13+)

---

**Issue**: Rich push notifications (images) not working

**Solution**: Ensure Notification Service Extension is properly configured on iOS (see [Notification Service Extension](#notification-service-extension))

### In-App Message Issues

**Issue**: In-app messages not displaying

**Checklist**:
- [ ] `siteId` configured in `inAppConfig`
- [ ] In-app messaging module initialized
- [ ] Event listener registered
- [ ] User identified before triggering message
- [ ] Message created and published in Zixflow dashboard
- [ ] Check logs for error events

---

**Issue**: In-app message events not firing

**Solution**: Ensure event listener is registered before messages are triggered:
```typescript
useEffect(() => {
  const listener = Zixflow.inAppMessaging.registerEventsListener((event) => {
    console.log('In-app event:', event);
  });

  return () => listener.remove();
}, []);
```

---

## Example Applications

The Zixflow React Native SDK includes example applications demonstrating best practices:

### Sample App (APNs)

Location: `example/`

**Features**:
- User identification and logout
- Event tracking
- Screen tracking with React Navigation
- Push notifications with APNs
- In-app messaging with event listeners
- Profile and device attributes

**Running the example**:

```bash
# Install dependencies
cd example
npm install

# iOS
cd ios && pod install && cd ..
npx react-native run-ios

# Android
npx react-native run-android
```

---

## API Reference

### Core SDK

#### `Zixflow.initialize(config: CioConfig): void`

Initialize the SDK with configuration.

```typescript
Zixflow.initialize({
  cdpApiKey: 'YOUR_API_KEY',
  region: Region.US,
});
```

#### `Zixflow.identify(params: { userId: string; traits?: object }): void`

Identify a user with optional traits.

```typescript
Zixflow.identify({
  userId: 'user-123',
  traits: { email: 'user@example.com' }
});
```

#### `Zixflow.clearIdentify(): void`

Clear the current user's identity.

```typescript
Zixflow.clearIdentify();
```

#### `Zixflow.track(name: string, properties?: object | Map<string, any>): void`

Track a custom event.

```typescript
Zixflow.track('button_clicked', { button_name: 'signup' });
```

#### `Zixflow.screen(name: string, properties?: object): void`

Track a screen view.

```typescript
Zixflow.screen('HomeScreen');
```

#### `Zixflow.setProfileAttributes(attributes: object): void`

Set attributes on the user profile.

```typescript
Zixflow.setProfileAttributes({ plan: 'premium' });
```

#### `Zixflow.setDeviceAttributes(attributes: object): void`

Set attributes on the current device.

```typescript
Zixflow.setDeviceAttributes({ app_version: '2.0.0' });
```

### Push Messaging

#### `Zixflow.pushMessaging.showPromptForPushNotifications(options): Promise<CioPushPermissionStatus>`

Request push notification permission.

```typescript
const status = await Zixflow.pushMessaging.showPromptForPushNotifications({
  ios: { sound: true, badge: true }
});
```

### In-App Messaging

#### `Zixflow.inAppMessaging.registerEventsListener(callback): EventSubscription`

Register a listener for in-app message events.

```typescript
const listener = Zixflow.inAppMessaging.registerEventsListener((event) => {
  console.log('In-app event:', event);
});

// Remove listener
listener.remove();
```

#### `Zixflow.inAppMessaging.dismissMessage(): void`

Dismiss the currently displayed in-app message.

```typescript
Zixflow.inAppMessaging.dismissMessage();
```

### Types

#### `CioConfig`

Configuration object for SDK initialization.

```typescript
interface CioConfig {
  cdpApiKey: string;
  region?: Region;
  logLevel?: CioLogLevel;
  inAppConfig?: {
    siteId: string;
  };
  autoTrackDeviceAttributes?: boolean;
  trackApplicationLifecycleEvents?: boolean;
  autoTrackScreenViews?: boolean;
  trackingApiUrl?: string;
}
```

#### `Region`

Data center region enum.

```typescript
enum Region {
  US = 'US',
  EU = 'EU'
}
```

#### `CioLogLevel`

Log level enum.

```typescript
enum CioLogLevel {
  none = 'none',
  error = 'error',
  info = 'info',
  debug = 'debug'
}
```

#### `CioPushPermissionStatus`

Push notification permission status.

```typescript
enum CioPushPermissionStatus {
  Granted = 'granted',
  Denied = 'denied',
  NotDetermined = 'notDetermined'
}
```

#### `InAppMessageEventType`

In-app message event types.

```typescript
enum InAppMessageEventType {
  messageShown = 'messageShown',
  messageDismissed = 'messageDismissed',
  messageActionTaken = 'messageActionTaken',
  errorWithMessage = 'errorWithMessage'
}
```

#### `InAppMessageEvent`

In-app message event object.

```typescript
interface InAppMessageEvent {
  eventType: InAppMessageEventType;
  deliveryId?: string;
  messageId?: string;
  actionName?: string;
  actionValue?: string;
}
```

---

## Support & Resources

### Documentation

- **GitHub Repository**: https://github.com/zixflow/zixflow-reactnative
- **iOS SDK Documentation**: https://github.com/zixflow/zixflow-ios
- **Android SDK Documentation**: https://github.com/zixflow/zixflow-android
- **API Reference**: See [API Reference](#api-reference) section above

### Getting Help

- **GitHub Issues**: https://github.com/zixflow/zixflow-reactnative/issues
- **Support Email**: support@zixflow.com

### Changelog

See [CHANGELOG.md](../CHANGELOG.md) for version history and release notes.

---

**Need help?** Contact our support team at support@zixflow.com or open an issue on GitHub.
