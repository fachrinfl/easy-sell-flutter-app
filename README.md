# EasySell POS - Flutter Point of Sale Application

A comprehensive Flutter-based Point of Sale (POS) application with Firebase backend integration, designed for small to medium businesses. Features real-time inventory management, transaction processing, analytics, and cross-platform support.

## 📱 Download & Demo

- **📦 APK Download**: [Download EasySell APK](https://drive.google.com/file/d/1liUgN9hQD0kx9a50quQH4VCL3PHMlXQS/view?usp=drive_link)
- **🎬 Demo Video**: [Watch App Demo](https://drive.google.com/file/d/1ZmdiKXy_djYtxf7nd3qsNFwYepiCLhH8/view?usp=drive_link)

### 🧪 Demo Account

To test the application with pre-populated data, use the following demo account:

- **Email**: `fachri@mail.com`
- **Password**: `Panada123$`

This demo account includes:

- Sample products in inventory
- Transaction history with various payment methods
- Business analytics and reports
- Complete POS functionality

## 🚀 Features

### Core Business Features

- **Authentication System**: Secure email/password registration and login with form validation
- **Business Management**: Business name setup and profile management with real-time updates
- **Inventory Management**: Complete product CRUD operations with stock tracking and low stock alerts
- **Point of Sale**: Real-time transaction processing with multiple payment methods (Cash, Card, Transfer)
- **Transaction History**: Comprehensive transaction tracking with real-time updates, search, and filtering
- **Reports & Analytics**: Business insights with sales trends, top products, and performance metrics
- **Settings Management**: User preferences and business configuration

### Technical Features

- **Cross-Platform**: Native performance on both Android and iOS with platform-specific optimizations
- **Real-time Data**: Live updates across all features using Firebase StreamProvider
- **State Management**: Riverpod for efficient state management with automatic invalidation
- **Clean Architecture**: Organized code structure with separation of concerns
- **Offline Support**: Local data caching with Hive for improved performance
- **Modern UI**: Material Design 3 with custom design system and shimmer loading effects

## 📁 Project Structure

```
lib/
├── core/                          # Core application logic
│   ├── navigation/                # Routing and navigation (GoRouter)
│   ├── services/                  # Business logic services (Firebase, Auth, etc.)
│   └── theme/                     # Design system (colors, typography, spacing)
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication feature
│   │   ├── models/               # Auth-related data models
│   │   └── pages/                # Auth screens (login, register, forgot password)
│   └── pos/                       # Point of Sale models
│       └── models/               # Transaction, Product, Cart models
├── shared/                        # Shared components
│   ├── widgets/                   # Reusable UI components
│   │   ├── atoms/                # Basic components (buttons, text fields, cards)
│   │   ├── molecules/            # Composite components (forms, navigation, headers)
│   │   ├── organisms/            # Complex components (product cards, cart panels)
│   │   └── pages/                # Full page components (POS, Inventory, Reports, etc.)
│   └── utils/                     # Utility functions
└── main.dart                      # Application entry point

```

### Architecture Layers

- **Presentation Layer**: UI components and pages with Riverpod state management
- **Domain Layer**: Business logic and models with Freezed data classes
- **Data Layer**: Firebase services (Auth, Firestore, Storage) and local storage (Hive)

### Key Improvements Made

- **Streamlined Architecture**: Removed unused components and consolidated similar functionality
- **Real-time Updates**: Transaction history now updates automatically when new transactions are created
- **Client-side Filtering**: Improved performance with local search, filtering, and sorting
- **Code Cleanup**: Removed unused files, imports, and dependencies for better maintainability
- **Unified Data Flow**: Consistent use of StreamProvider for real-time data across all features

## Package Configuration

### Changing Package Name and Build Name

### For Android:

1. **Update `android/app/build.gradle`**:

   ```
   android {
       defaultConfig {
           applicationId "com.yourcompany.easysell"  // Change this
           versionName "1.0.0"                      // Change this
           versionCode 1                            // Change this
       }
   }

   ```

2. **Update package structure**:

   ```bash
   # Navigate to android/app/src/main/kotlin/
   # Rename the directory structure to match your package name
   # Example: com/yourcompany/easysell/

   ```

3. **Update `AndroidManifest.xml`**:

   ```xml
   <manifest xmlns:android="<http://schemas.android.com/apk/res/android>"
       package="com.yourcompany.easysell">

   ```

### For iOS:

1. **Update `ios/Runner/Info.plist`**:

   ```xml
   <key>CFBundleIdentifier</key>
   <string>com.yourcompany.easysell</string>
   <key>CFBundleName</key>
   <string>EasySell</string>

   ```

2. **Update Xcode project**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Change Bundle Identifier in project settings
   - Update Display Name

### For Flutter:

1. **Update `pubspec.yaml`**:

   ```yaml
   name: easysell_pos # Change this
   description: "EasySell Point of Sale Application"
   version: 1.0.0+1
   ```

## Firebase Setup

### Prerequisites

- Firebase CLI installed: `npm install -g firebase-tools`
- Flutter project with Firebase dependencies

### Step 1: Firebase Project Setup

1. **Create Firebase Project**:

   ```bash
   # Login to Firebase
   firebase login

   # Create new project (or use existing)
   firebase projects:create your-project-id

   ```

2. **Initialize Firebase in your project**:

   ```bash
   # Navigate to your Flutter project root
   firebase init

   # Select the following services:
   # - Firestore Database
   # - Firebase Hosting (optional)
   # - Firebase Storage

   ```

### Step 2: Configure Firebase for Flutter

1. **Install FlutterFire CLI**:

   ```bash
   dart pub global activate flutterfire_cli

   ```

2. **Configure Firebase for your platforms**:

   ```bash
   # Configure for all platforms
   flutterfire configure

   # Or configure individually
   flutterfire configure --platforms=android,ios

   ```

3. **Download configuration files**:
   - `android/app/google-services.json` (Android)
   - `ios/Runner/GoogleService-Info.plist` (iOS)

### Step 3: Firebase Security Rules

1. **Deploy Firestore Rules**:

   ```bash
   # Deploy security rules
   firebase deploy --only firestore:rules

   ```

2. **Deploy Storage Rules**:

   ```bash
   # Deploy storage rules
   firebase deploy --only storage

   ```

3. **Deploy Firestore Indexes**:

   ```bash
   # Deploy database indexes
   firebase deploy --only firestore:indexes

   ```

### Step 4: Firebase CLI Commands

```bash
# View current project
firebase projects:list

# Switch to your project
firebase use your-project-id

# Deploy all rules and indexes
firebase deploy

# Deploy specific services
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
firebase deploy --only storage

```

### Step 5: Environment Configuration

1. **Update `lib/core/services/firebase_service.dart`** with your project settings
2. **Verify Firebase connection** in your app
3. **Test authentication** and database operations

## Running the Project

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase CLI (for backend management)

### Development Setup

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd sample_flutter_app

   ```

2. **Install dependencies**:

   ```bash
   flutter pub get

   ```

3. **Generate code** (if using code generation):

   ```bash
   flutter packages pub run build_runner build

   ```

### Running on Android

1. **Start Android emulator** or connect physical device
2. **Run the app**:

   ```bash
   flutter run
   # Or specify device
   flutter run -d <device-id>

   ```

3. **For release build**:

   ```bash
   flutter build apk --release

   ```

### Running on iOS

1. **Open iOS Simulator** or connect iOS device
2. **Install iOS dependencies**:

   ```bash
   cd ios
   pod install
   cd ..

   ```

3. **Run the app**:

   ```bash
   flutter run -d <ios-device-id>

   ```

4. **For release build**:

   ```bash
   flutter build ios --release

   ```

### Development Commands

```bash
# Hot reload during development
flutter run --hot

# Clean and rebuild
flutter clean
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

```

### Troubleshooting iOS Build Issues

If you encounter iOS build issues (especially with Xcode 16):

1. **Clean build**:

   ```bash
   flutter clean
   cd ios
   rm -rf Pods Podfile.lock
   pod install --repo-update
   cd ..

   ```

2. **The project includes automatic fixes for**:
   - gRPC-Core template argument parsing errors
   - BoringSSL-GRPC bundle issues
   - Firebase SDK compatibility with Xcode 16

## Development Tools

### State Management

- **Riverpod**: Primary state management with StreamProvider for real-time data
- **Provider**: For dependency injection and service management
- **StateNotifier**: For complex state logic and business rules

### Backend Services

- **Firebase Authentication**: User management with email/password authentication
- **Cloud Firestore**: Real-time database with automatic synchronization
- **Firebase Storage**: File storage for product images and documents
- **Firebase Security Rules**: Comprehensive security for data access control

### Local Storage

- **Hive**: Local database for offline support and caching
- **SharedPreferences**: For user preferences and settings

### UI/UX

- **Material Design 3**: Modern UI components with custom theming
- **Atomic Design System**: Organized component hierarchy (atoms, molecules, organisms)
- **Shimmer Effects**: Loading placeholders for better user experience
- **Responsive Design**: Cross-platform compatibility with platform-specific optimizations
- **Real-time Updates**: Live data synchronization across all screens

## Recent Updates & Improvements

### Transaction History Enhancements

- **Real-time Updates**: Transactions now appear immediately after creation without manual refresh
- **Improved Performance**: Client-side filtering and sorting for faster user experience
- **Enhanced Search**: Search by transaction ID, product names, payment methods, and status
- **Better UX**: Pull-to-refresh functionality and shimmer loading effects

### Code Quality Improvements

- **Removed Unused Code**: Cleaned up unused components, imports, and dependencies
- **Streamlined Architecture**: Consolidated similar functionality and removed duplicate code
- **Better State Management**: Unified data flow using StreamProvider for consistency
- **Improved Error Handling**: Better error messages and user feedback

### Technical Optimizations

- **Firebase Integration**: Optimized Firestore queries and real-time listeners
- **Memory Management**: Improved widget lifecycle and state management
- **Cross-platform Compatibility**: Enhanced iOS and Android specific optimizations
- **Build Performance**: Faster compilation and hot reload times

## Supported Platforms

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 14.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**EasySell POS** - Streamlining business operations with modern technology.
