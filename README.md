<p align="center">
  <a href="https://zixflow.com">
    <img src="https://zixflow.com/logo.svg" height="60">
  </a>
</p>

[![npm version](https://img.shields.io/npm/v/zixflow-reactnative.svg)](https://www.npmjs.com/package/zixflow-reactnative)
[![npm downloads](https://img.shields.io/npm/dm/zixflow-reactnative)](https://www.npmjs.com/package/zixflow-reactnative)
![min Android SDK version is 21](https://img.shields.io/badge/min%20Android%20SDK-21-green)
![min iOS version is 13](https://img.shields.io/badge/min%20iOS%20version-13-blue)
![min Swift version is 5.3](https://img.shields.io/badge/min%20Swift%20version-5.3-orange)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](CODE_OF_CONDUCT.md)

# Zixflow React Native SDK

The official Zixflow SDK for React Native enables you to integrate customer engagement features—like in-app messaging and push notifications—into your app. Track customer behavior, send targeted messages, and create personalized experiences.

> 📖 Full documentation: [zixflow.com/docs/sdk/react-native](https://zixflow.com/docs/sdk/react-native/)
> 🧪 Example apps: [see the `/example` directory](/example)

---

## About Zixflow

Zixflow is a customer engagement platform built on proven Customer.io technology. This SDK is a customized fork of the Customer.io React Native SDK, optimized for use with the Zixflow platform.

### Key Features

- 📊 Customer identification and event tracking
- 📲 Push notifications (iOS APN and Android FCM)
- 💬 In-app messaging
- 📍 Location tracking (optional)
- 🎯 Personalized customer experiences
- 📈 Analytics and customer data pipelines
- 🔧 TypeScript support
- ⚡ React Native New Architecture (TurboModules) support

---

## Installation

```bash
npm install zixflow-reactnative
```

or

```bash
yarn add zixflow-reactnative
```

---

## Quick Start

### SDK Initialization

Here's a simplified example showing how to initialize the SDK to enable mobile features:

```ts
import {
  Zixflow,
  ZixflowConfig,
  CioLogLevel,
  CioRegion,
} from 'zixflow-reactnative';

useEffect(() => {
  const config: ZixflowConfig = {
    cdpApiKey: 'your-api-key', // Required
    migrationSiteId: 'your-site-id', // Optional, for migrating from older SDKs
    region: CioRegion.US, // Or CioRegion.EU
    logLevel: CioLogLevel.debug,
    trackApplicationLifecycleEvents: true,
    inApp: {
      siteId: 'your-site-id', // Required for in-app messaging
    },
    push: {
      android: {
        pushClickBehavior: 'ActivityPreventRestart', // Optional
      },
    },
  };

  Zixflow.initialize(config);
}, []);
```

> 🔑 For help finding your credentials, check out the [Quick Start Guide](https://zixflow.com/docs/sdk/react-native/quick-start-guide/).

---

## Core Features

### 👤 Identify Users

Associate events and devices with customer profiles:

```ts
Zixflow.identify({
  userId: 'user123',
  traits: {
    email: 'user@example.com',
    firstName: 'John',
    lastName: 'Doe',
    plan: 'premium',
  },
});
```

### 📊 Track Events

Track custom events to trigger messaging based on user behavior:

```ts
Zixflow.track('Product Viewed', {
  productId: '12345',
  productName: 'Awesome Product',
  price: 49.99,
  category: 'Electronics',
});
```

### 📺 Screen Tracking

Track screen views in your app:

```ts
Zixflow.screen('Product Details', {
  productId: '12345',
  category: 'Electronics',
});
```

### 🏷️ Set Profile Attributes

Update customer profile attributes:

```ts
Zixflow.setProfileAttributes({
  plan: 'enterprise',
  lastSeenAt: Date.now(),
  preferences: {
    notifications: true,
    newsletter: true,
  },
});
```

---

## 📲 Push Notifications

This SDK supports rich push notifications using Firebase (for Android) and either Firebase or APNs (for iOS).

### Request Permission (iOS)

```ts
const status = await Zixflow.pushMessaging.showPromptForPushNotifications();
console.log('Push permission status:', status);
```

### Handle Push Notifications

```ts
// Track when user receives a notification
Zixflow.pushMessaging.onMessageReceived((message) => {
  console.log('Notification received:', message);
});

// Track when user clicks on a notification
Zixflow.pushMessaging.onBackgroundMessageReceived((message) => {
  console.log('Notification clicked:', message);
});
```

Follow our [push setup guide](https://zixflow.com/docs/sdk/react-native/push/) to configure your project for push.

---

## 💬 In-App Messaging

Display in-app messages to your users:

```ts
import { InAppMessageEvent, InAppMessageEventType } from 'zixflow-reactnative';

// Register event listener
Zixflow.inAppMessaging.registerEventsListener((event: InAppMessageEvent) => {
  switch (event.eventType) {
    case InAppMessageEventType.MessageShown:
      console.log('In-app message shown:', event.message);
      break;
    case InAppMessageEventType.MessageClicked:
      console.log('In-app message clicked:', event.message);
      break;
    case InAppMessageEventType.MessageDismissed:
      console.log('In-app message dismissed:', event.message);
      break;
  }
});

// Dismiss message programmatically
Zixflow.inAppMessaging.dismissMessage();
```

### Inbox Messages

Manage inbox messages:

```ts
const inbox = Zixflow.inAppMessaging.inbox();

// Get all messages
const messages = await inbox.getMessages();

// Mark message as read
await inbox.markMessageOpened(messageId);

// Delete message
await inbox.markMessageDeleted(messageId);

// Subscribe to inbox updates
inbox.subscribeToMessages((messages) => {
  console.log('Inbox updated:', messages);
});
```

---

## 📍 Location Tracking

Track user location (optional feature):

```ts
Zixflow.location.setLastKnownLocation(latitude, longitude);
```

---

## Advanced Features

### Device Attributes

Set custom device attributes:

```ts
Zixflow.setDeviceAttributes({
  deviceModel: 'iPhone 14 Pro',
  appVersion: '2.1.0',
  customAttribute: 'value',
});
```

### Register Device Token

Register a device token for push notifications:

```ts
Zixflow.registerDeviceToken('your-device-token');
```

### Clear Identification

Clear the current user identification:

```ts
Zixflow.clearIdentify();
```

---

## Platform-Specific Setup

### iOS Setup

1. Add pods to your `ios/Podfile`:

```ruby
pod 'zixflow-reactnative', :path => '../node_modules/zixflow-reactnative'

# For FCM push:
pod 'zixflow-reactnative/fcm', :path => '../node_modules/zixflow-reactnative'

# For APN push:
pod 'zixflow-reactnative/apn', :path => '../node_modules/zixflow-reactnative'

# For location tracking:
pod 'zixflow-reactnative/location', :path => '../node_modules/zixflow-reactnative'
```

2. Run `pod install` in the `ios` directory

3. Follow the [iOS push setup guide](https://zixflow.com/docs/sdk/react-native/push/ios)

### Android Setup

1. The SDK is automatically linked via autolinking

2. (Optional) Enable location tracking in `android/gradle.properties`:

```properties
zixflow_location_enabled=true
```

3. Follow the [Android push setup guide](https://zixflow.com/docs/sdk/react-native/push/android)

---

## Configuration Options

| Option | Type | Required | Description |
|--------|------|----------|-------------|
| `cdpApiKey` | `string` | ✅ | Your Zixflow API key |
| `migrationSiteId` | `string` | ❌ | Site ID for migration from older SDKs |
| `region` | `CioRegion` | ❌ | US or EU region (default: US) |
| `logLevel` | `CioLogLevel` | ❌ | Logging verbosity (default: error) |
| `trackApplicationLifecycleEvents` | `boolean` | ❌ | Auto-track app lifecycle events |
| `inApp` | `object` | ❌ | In-app messaging configuration |
| `push` | `object` | ❌ | Push notification configuration |

---

## TypeScript Support

This SDK is written in TypeScript and includes full type definitions:

```ts
import type {
  Zixflow,
  ZixflowConfig,
  ZixflowInAppMessaging,
  ZixflowPushMessaging,
  ZixflowLocation,
  CustomAttributes,
  IdentifyParams,
  InAppMessage,
  InboxMessage,
} from 'zixflow-reactnative';
```

---

## Module APIs

Access specific SDK modules:

```ts
// In-app messaging
Zixflow.inAppMessaging.registerEventsListener(listener);

// Push messaging
Zixflow.pushMessaging.showPromptForPushNotifications();

// Location tracking
Zixflow.location.setLastKnownLocation(lat, lng);
```

Note: Due to JavaScript limitations, module properties return the internal implementation instances, but all functionality works as expected.

---

## Example App

Check out our comprehensive [example app](/example) that demonstrates:

- SDK initialization
- User identification
- Event tracking
- Push notifications
- In-app messaging
- Location tracking
- Inbox management

To run the example app:

```bash
cd example
npm install

# iOS
cd ios && pod install && cd ..
npx react-native run-ios

# Android
npx react-native run-android
```

---

## Troubleshooting

### Common Issues

**Issue: Build fails with "Zixflow pod not found"**
- Run `pod install` in your iOS directory
- Make sure you're using the correct pod name: `zixflow-reactnative`

**Issue: Push notifications not working**
- Verify your Firebase configuration (Android) or APNs certificates (iOS)
- Check that you've requested push permissions
- Ensure you've registered the device token

**Issue: In-app messages not showing**
- Verify you've configured `inApp.siteId` in the config
- Check that you've registered an events listener
- Ensure messages are targeted correctly in your Zixflow dashboard

For more help, see our [troubleshooting guide](https://zixflow.com/docs/sdk/react-native/troubleshooting/) or [open an issue](https://github.com/zixflow/zixflow-reactnative/issues).

---

## Requirements

- React Native 0.70+
- iOS 13+
- Android API 21+ (Android 5.0 Lollipop)
- Swift 5.3+
- Kotlin 1.8+

---

## Contributing

We welcome contributions! To get started:

1. Review our [example app](/example) to help with local development
2. Follow our [Code of Conduct](CODE_OF_CONDUCT.md)
3. Check out [DEVELOPMENT.md](DEVELOPMENT.md) for development guidelines
4. Open issues or pull requests on [GitHub](https://github.com/zixflow/zixflow-reactnative)

---

## Support

- 📚 [Documentation](https://zixflow.com/docs/sdk/react-native/)
- 💬 [Community Forum](https://community.zixflow.com)
- 🐛 [Issue Tracker](https://github.com/zixflow/zixflow-reactnative/issues)
- 📧 Email: apps@zixflow.com

---

## License

[MIT](LICENSE)

---

## Acknowledgments

This SDK is based on the Customer.io React Native SDK and maintains compatibility with the Customer.io platform while providing Zixflow-specific optimizations and branding.
