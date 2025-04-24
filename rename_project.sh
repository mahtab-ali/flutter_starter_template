#!/bin/bash

# Flutter Project Rename Script
# This script reads the current project name from AppConfig and prompts for a new name
# Usage: ./rename_project.sh

set -e  # Exit on any error

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

# Extract bundle IDs
OLD_BUNDLE_ID=$(grep "bundleId = '" "$CONFIG_FILE" | sed "s/.*bundleId = '\([^']*\)'.*/\1/")
if [ -z "$OLD_BUNDLE_ID" ]; then
  OLD_BUNDLE_ID="com.example.$OLD_NAME"
fi

# Extract the bundle ID prefix (e.g., "com.app" from "com.app.loopwise")
BUNDLE_PREFIX=$(echo "$OLD_BUNDLE_ID" | sed "s/\(.*\)\.$OLD_NAME/\1/")

# Create capitalized version of the package name (for imports like 'package:Loopwise/')
OLD_NAME_CAPITALIZED="$(tr '[:lower:]' '[:upper:]' <<< ${OLD_NAME:0:1})${OLD_NAME:1}"

# Display current project information
echo "📋 Current Project Information"
echo "  Name: $OLD_NAME"
echo "  Capitalized Name: $OLD_NAME_CAPITALIZED"
echo "  Bundle ID: $OLD_BUNDLE_ID"
echo ""

# Prompt user for new project name
echo "Enter a new project name (leave empty to keep '$OLD_NAME'):"
read NEW_NAME

# If no name provided, exit
if [ -z "$NEW_NAME" ]; then
  echo "No new name provided. Keeping current name: $OLD_NAME"
  exit 0
fi

# Create capitalized version of the new name
NEW_NAME_CAPITALIZED="$(tr '[:lower:]' '[:upper:]' <<< ${NEW_NAME:0:1})${NEW_NAME:1}"

# Use the same prefix for the new bundle ID
NEW_BUNDLE_ID="$BUNDLE_PREFIX.$NEW_NAME"

# Display rename information
echo ""
echo "🚀 Renaming Flutter project"
echo "  From: $OLD_NAME"
echo "  To:   $NEW_NAME"
echo ""
echo "  From capitalized: $OLD_NAME_CAPITALIZED"
echo "  To capitalized:   $NEW_NAME_CAPITALIZED"
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
  
  # Extract iOS bundle ID and format
  OLD_IOS_ID=$(grep "appIdIos = '" "$CONFIG_FILE" | sed "s/.*appIdIos = '\([^']*\)'.*/\1/")
  if [ -n "$OLD_IOS_ID" ]; then
    IOS_PREFIX=$(echo "$OLD_IOS_ID" | sed "s/\(.*\)\.[^.]*/\1/")
    NEW_IOS_ID="$IOS_PREFIX.${NEW_NAME//-/}"
    sed -i '' "s/appIdIos = '$OLD_IOS_ID'/appIdIos = '$NEW_IOS_ID'/" $CONFIG_FILE
  else
    sed -i '' "s/appIdIos = 'com.example.[^']*'/appIdIos = '$BUNDLE_PREFIX.${NEW_NAME//-/}'/" $CONFIG_FILE
  fi
else  # Linux and others
  sed -i "s/packageName = '$OLD_NAME'/packageName = '$NEW_NAME'/" $CONFIG_FILE
  sed -i "s/bundleId = '$OLD_BUNDLE_ID'/bundleId = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  sed -i "s/appIdAndroid = '$OLD_BUNDLE_ID'/appIdAndroid = '$NEW_BUNDLE_ID'/" $CONFIG_FILE
  
  # Extract iOS bundle ID and format
  OLD_IOS_ID=$(grep "appIdIos = '" "$CONFIG_FILE" | sed "s/.*appIdIos = '\([^']*\)'.*/\1/")
  if [ -n "$OLD_IOS_ID" ]; then
    IOS_PREFIX=$(echo "$OLD_IOS_ID" | sed "s/\(.*\)\.[^.]*/\1/")
    NEW_IOS_ID="$IOS_PREFIX.${NEW_NAME//-/}"
    sed -i "s/appIdIos = '$OLD_IOS_ID'/appIdIos = '$NEW_IOS_ID'/" $CONFIG_FILE
  else
    sed -i "s/appIdIos = 'com.example.[^']*'/appIdIos = '$BUNDLE_PREFIX.${NEW_NAME//-/}'/" $CONFIG_FILE
  fi
fi

# 3. Update import statements in all Dart files
echo "📄 Updating import statements in Dart files..."
DART_FILES=$(find lib -name "*.dart")
for file in $DART_FILES; do
  echo "   Processing $file"
  if [ "$(uname)" == "Darwin" ]; then  # macOS
    # Update lowercase version
    sed -i '' "s/package:$OLD_NAME\//package:$NEW_NAME\//g" "$file"
    # Update capitalized version
    sed -i '' "s/package:$OLD_NAME_CAPITALIZED\//package:$NEW_NAME_CAPITALIZED\//g" "$file"
  else  # Linux and others
    sed -i "s/package:$OLD_NAME\//package:$NEW_NAME\//g" "$file"
    sed -i "s/package:$OLD_NAME_CAPITALIZED\//package:$NEW_NAME_CAPITALIZED\//g" "$file"
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
    
    # Use the same iOS bundle ID format as in AppConfig.dart
    OLD_IOS_ID=$(grep "appIdIos = '" "$CONFIG_FILE" | sed "s/.*appIdIos = '\([^']*\)'.*/\1/")
    if [ -n "$OLD_IOS_ID" ]; then
      IOS_PREFIX=$(echo "$OLD_IOS_ID" | sed "s/\(.*\)\.[^.]*/\1/")
      NEW_IOS_ID="$IOS_PREFIX.${NEW_NAME//-/}"
      sed -i '' "s/$OLD_IOS_ID/$NEW_IOS_ID/" "$IOS_INFO_PLIST"
    else
      sed -i '' "s/$BUNDLE_PREFIX\.[^<]*/$BUNDLE_PREFIX.${NEW_NAME//-/}/" "$IOS_INFO_PLIST"
    fi
  else  # Linux and others
    sed -i "s/<string>$OLD_NAME<\/string>/<string>$NEW_NAME<\/string>/" "$IOS_INFO_PLIST"
    
    # Use the same iOS bundle ID format as in AppConfig.dart
    OLD_IOS_ID=$(grep "appIdIos = '" "$CONFIG_FILE" | sed "s/.*appIdIos = '\([^']*\)'.*/\1/")
    if [ -n "$OLD_IOS_ID" ]; then
      IOS_PREFIX=$(echo "$OLD_IOS_ID" | sed "s/\(.*\)\.[^.]*/\1/")
      NEW_IOS_ID="$IOS_PREFIX.${NEW_NAME//-/}"
      sed -i "s/$OLD_IOS_ID/$NEW_IOS_ID/" "$IOS_INFO_PLIST"
    else
      sed -i "s/$BUNDLE_PREFIX\.[^<]*/$BUNDLE_PREFIX.${NEW_NAME//-/}/" "$IOS_INFO_PLIST"
    fi
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