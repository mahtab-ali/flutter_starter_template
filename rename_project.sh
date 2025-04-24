#!/bin/bash

# Flutter Project Rename Script
# This script reads the current project name from AppConfig and renames it to a new name
# Usage: ./rename_project.sh <new_project_name>

set -e  # Exit on any error

# Check if a new project name was provided
if [ -z "$1" ]; then
  echo "Error: Please provide a new project name"
  echo "Usage: ./rename_project.sh <new_project_name>"
  exit 1
fi

# Read the current project name from AppConfig.dart
CONFIG_FILE="lib/config/app_config.dart"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE does not exist"
  exit 1
fi

# Extract the current package name from AppConfig.dart
OLD_NAME=$(grep "packageName = '" "$CONFIG_FILE" | sed "s/.*packageName = '\([^']*\)'.*/\1/")

if [ -z "$OLD_NAME" ]; then
  echo "Error: Could not determine current package name from $CONFIG_FILE"
  exit 1
fi

NEW_NAME=$1

# Extract bundle IDs
OLD_BUNDLE_ID=$(grep "bundleId = '" "$CONFIG_FILE" | sed "s/.*bundleId = '\([^']*\)'.*/\1/")
if [ -z "$OLD_BUNDLE_ID" ]; then
  OLD_BUNDLE_ID="com.example.$OLD_NAME"
fi
NEW_BUNDLE_ID="com.example.$NEW_NAME"

# Display rename information
echo "🚀 Renaming Flutter project"
echo "  From: $OLD_NAME"
echo "  To:   $NEW_NAME"
echo ""
echo "  From bundle ID: $OLD_BUNDLE_ID"
echo "  To bundle ID:   $NEW_BUNDLE_ID"
echo ""
echo "This will modify files in the current directory."
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled"
  exit 0
fi

# 1. Update pubspec.yaml
echo "📄 Updating pubspec.yaml..."
if [ "$(uname)" == "Darwin" ]; then  # macOS
  sed -i '' "s/name: $OLD_NAME/name: $NEW_NAME/" pubspec.yaml
else  # Linux and others
  sed -i "s/name: $OLD_NAME/name: $NEW_NAME/" pubspec.yaml
fi

# 2. Update app_config.dart
echo "📄 Updating app_config.dart..."
if [ "$(uname)" == "Darwin" ]; then  # macOS
  sed -i '' "s/packageName = '$OLD_NAME'/packageName = '$NEW_NAME'/" $CONFIG_FILE
  sed -i '' "s/bundleId = '$OLD_BUNDLE_ID'/bundleId = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  sed -i '' "s/appIdAndroid = '$OLD_BUNDLE_ID'/appIdAndroid = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  sed -i '' "s/appIdIos = 'com.example.[^']*'/appIdIos = 'com.example.${NEW_NAME//-/}'/" $CONFIG_FILE
else  # Linux and others
  sed -i "s/packageName = '$OLD_NAME'/packageName = '$NEW_NAME'/" $CONFIG_FILE
  sed -i "s/bundleId = '$OLD_BUNDLE_ID'/bundleId = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  sed -i "s/appIdAndroid = '$OLD_BUNDLE_ID'/appIdAndroid = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  sed -i "s/appIdIos = 'com.example.[^']*'/appIdIos = 'com.example.${NEW_NAME//-/}'/" $CONFIG_FILE
fi

# 3. Update import statements in all Dart files
echo "📄 Updating import statements in Dart files..."
DART_FILES=$(find lib -name "*.dart")
for file in $DART_FILES; do
  echo "   Processing $file"
  if [ "$(uname)" == "Darwin" ]; then  # macOS
    sed -i '' "s/package:$OLD_NAME\//package:$NEW_NAME\//g" "$file"
  else  # Linux and others
    sed -i "s/package:$OLD_NAME\//package:$NEW_NAME\//g" "$file"
  fi
done

# 4. Update Android configuration
echo "📄 Updating Android configuration..."
# android/app/build.gradle.kts
ANDROID_BUILD_GRADLE="android/app/build.gradle.kts"
if [ -f "$ANDROID_BUILD_GRADLE" ]; then
  echo "   Processing $ANDROID_BUILD_GRADLE"
  if [ "$(uname)" == "Darwin" ]; then  # macOS
    sed -i '' "s/namespace = \"$OLD_BUNDLE_ID\"/namespace = \"$NEW_BUNDLE_ID\"/" "$ANDROID_BUILD_GRADLE"
    sed -i '' "s/applicationId = \"$OLD_BUNDLE_ID\"/applicationId = \"$NEW_BUNDLE_ID\"/" "$ANDROID_BUILD_GRADLE"
  else  # Linux and others
    sed -i "s/namespace = \"$OLD_BUNDLE_ID\"/namespace = \"$NEW_BUNDLE_ID\"/" "$ANDROID_BUILD_GRADLE"
    sed -i "s/applicationId = \"$OLD_BUNDLE_ID\"/applicationId = \"$NEW_BUNDLE_ID\"/" "$ANDROID_BUILD_GRADLE"
  fi
fi

# android/app/src/main/AndroidManifest.xml
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$ANDROID_MANIFEST" ]; then
  echo "   Processing $ANDROID_MANIFEST"
  if [ "$(uname)" == "Darwin" ]; then  # macOS
    sed -i '' "s/package=\"$OLD_BUNDLE_ID\"/package=\"$NEW_BUNDLE_ID\"/" "$ANDROID_MANIFEST"
  else  # Linux and others
    sed -i "s/package=\"$OLD_BUNDLE_ID\"/package=\"$NEW_BUNDLE_ID\"/" "$ANDROID_MANIFEST"
  fi
fi

# 5. Update iOS configuration
echo "📄 Updating iOS configuration..."
# ios/Runner/Info.plist
IOS_INFO_PLIST="ios/Runner/Info.plist"
if [ -f "$IOS_INFO_PLIST" ]; then
  echo "   Processing $IOS_INFO_PLIST"
  if [ "$(uname)" == "Darwin" ]; then  # macOS
    sed -i '' "s/<string>$OLD_NAME<\/string>/<string>$NEW_NAME<\/string>/" "$IOS_INFO_PLIST"
    sed -i '' "s/com.example.[^<]*/com.example.${NEW_NAME//-/}/" "$IOS_INFO_PLIST"
  else  # Linux and others
    sed -i "s/<string>$OLD_NAME<\/string>/<string>$NEW_NAME<\/string>/" "$IOS_INFO_PLIST"
    sed -i "s/com.example.[^<]*/com.example.${NEW_NAME//-/}/" "$IOS_INFO_PLIST"
  fi
fi

echo ""
echo "✅ Project renamed successfully from $OLD_NAME to $NEW_NAME"
echo ""
echo "Next steps:"
echo "1. Run 'flutter clean' to clean the build cache"
echo "2. Run 'flutter pub get' to update dependencies"
echo "3. Restart your IDE if it's currently open"
echo ""
echo "Note: You may need to manually update some references if the renaming was incomplete."