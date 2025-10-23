#!/bin/bash

# Firebase Setup Script for EasySell POS
# This script helps set up Firebase for the EasySell POS application

echo "🔥 Firebase Setup for EasySell POS"
echo "=================================="
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "Please install it first:"
    echo "npm install -g firebase-tools"
    echo ""
    exit 1
fi

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "❌ FlutterFire CLI is not installed."
    echo "Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
    echo ""
fi

echo "✅ Firebase CLI and FlutterFire CLI are installed"
echo ""

# Login to Firebase
echo "🔐 Logging into Firebase..."
firebase login
echo ""

# Create Firebase project (manual step)
echo "📝 Please create a Firebase project manually:"
echo "1. Go to https://console.firebase.google.com/"
echo "2. Click 'Create a project'"
echo "3. Project name: EasySell POS"
echo "4. Enable Google Analytics (recommended)"
echo "5. Click 'Create project'"
echo ""
read -p "Press Enter when you have created the Firebase project..."

# Get project ID
echo "🔍 Please enter your Firebase project ID:"
read -p "Project ID: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "❌ Project ID is required"
    exit 1
fi

echo ""
echo "🚀 Configuring Flutter app with Firebase..."
echo ""

# Configure Flutter app
flutterfire configure --project=$PROJECT_ID

echo ""
echo "📦 Installing Flutter dependencies..."
flutter pub get

echo ""
echo "🧹 Cleaning and rebuilding..."
flutter clean
flutter pub get

echo ""
echo "✅ Firebase setup completed!"
echo ""
echo "Next steps:"
echo "1. Enable Authentication in Firebase Console"
echo "2. Enable Firestore Database"
echo "3. Enable Firebase Storage"
echo "4. Test the app with: flutter run"
echo ""
echo "For detailed instructions, see docs/firebase-setup-guide.md"
