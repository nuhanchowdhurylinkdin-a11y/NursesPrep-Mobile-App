# Notification System — Setup & Usage

How to reuse the 5 notification service files in another Flutter project.

---

## 1. Copy the 5 Dart files

```
lib/core/services/notifications/
├── fcm_service.dart
├── fcm_token_sync.dart
├── local_notification_service.dart
├── notification_initializer.dart
└── notification_router.dart
```

Then adjust project-specific imports:

| File                       | What to change                                                                         |
| -------------------------- | -------------------------------------------------------------------------------------- |
| `fcm_service.dart`         | Relative path to `firebase_options.dart`                                               |
| `fcm_token_sync.dart`      | `ApiConstants.fcmToken`, `NetworkCaller`, `StorageService` → your HTTP + auth equivalents |
| `notification_router.dart` | `AppRoute.get…Screen()` calls → your route names                                        |

The other two files work as-is.

---

## 2. `pubspec.yaml` dependencies

```yaml
dependencies:
  firebase_core: ^4.7.0
  firebase_messaging: ^16.2.0
  flutter_local_notifications: ^21.0.0
  path_provider: ^2.1.5
  http: ^1.0.0
```

```bash
flutter pub get
```

---

## 3. Firebase project

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Generates `lib/firebase_options.dart`, drops `google-services.json` into `android/app/`, and `GoogleService-Info.plist` into `ios/Runner/`.

In **Firebase Console → Project settings → Cloud Messaging**, upload an **APNs Authentication Key (.p8)** — required for iOS push delivery.

---

## 4. Android configuration

### `android/settings.gradle.kts`

```kotlin
plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
    // ... existing plugins
}
```

### `android/app/build.gradle.kts`

```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")     // ← add
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true    // ← required for flutter_local_notifications
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")   // ← add
}
```

### `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>
        <!-- existing activities -->

        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default_channel" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />
    </application>

    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
</manifest>
```

The channel ID `default_channel` must match the one used in `LocalNotificationService`.

### SHA-1

Add your debug SHA-1 to Firebase Console → Android app → Add fingerprint, then re-download `google-services.json`.

```bash
cd android && ./gradlew signingReport
```

---

## 5. iOS configuration

### `ios/Podfile`

```ruby
platform :ios, '15.0'
```

### `ios/Runner.xcodeproj/project.pbxproj`

Change all three occurrences of `IPHONEOS_DEPLOYMENT_TARGET = 13.0;` to `15.0`.

### Xcode capabilities

Open `ios/Runner.xcworkspace` → Runner target → **Signing & Capabilities**:
- Click **+ Capability** → add **Push Notifications** (creates `Runner.entitlements`).
- Click **+ Capability** → add **Background Modes** → check **Remote notifications**.

### APNs Key (required for real device push)

1. Go to [Apple Developer](https://developer.apple.com) → **Certificates, Identifiers & Profiles** → **Keys**.
2. Click **+** → enable **Apple Push Notifications service (APNs)** → download the `.p8` file.
3. Note the **Key ID** (shown on the key page) and your **Team ID** (Account → Membership).
4. Go to **Firebase Console** → **Project Settings** → **Cloud Messaging** → **Apple app configuration**.
5. Upload the `.p8` file, enter the **Key ID** and **Team ID**.

> Without this step, FCM cannot deliver push notifications to real iOS devices. Simulator testing works without it (via `xcrun simctl push`).

### `ios/Runner/AppDelegate.swift`

```swift
import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {}
}
```

### Install pods

```bash
cd ios
pod repo update
pod install
```

---

## 6. Wire it in `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/services/notifications/notification_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationInitializer.init();
  runApp(const MyApp());
}
```

`Firebase.initializeApp` **must** run before `NotificationInitializer.init()`.

---

## 7. Hook into auth flow

```dart
// After login / signup
await FcmTokenSync.sync();

// Before logout
await FcmTokenSync.clear();

// On splash, after navigating to home (handles tap from killed state)
await FcmService.handleInitialMessage();
```

---

## 8. Backend contract

```
POST /users/fcm-token
Authorization: Bearer <access_token>
Body: { "fcmToken": "<token>" }
```

Send pushes with this payload shape:

```json
{
  "notification": { "title": "...", "body": "..." },
  "data": { "type": "payment_success" }
}
```

The `type` field drives routing in `NotificationRouter`.
