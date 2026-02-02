#!/bin/bash

# ============================================
# Version Bump Script for Android
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# File paths
VERSION_FILE="$PROJECT_ROOT/myapp/version.txt"
GRADLE_FILE="$PROJECT_ROOT/myapp/app/build.gradle"

# Get bump type
BUMP_TYPE="$1"

if [[ ! "$BUMP_TYPE" =~ ^(major|minor|patch)$ ]]; then
  echo "❌ Invalid bump type: $BUMP_TYPE"
  echo "Usage: ./version-bump.sh [major|minor|patch]"
  exit 1
fi

# Read current version
if [ -f "$VERSION_FILE" ]; then
  VERSION=$(sed -n '1p' "$VERSION_FILE" | tr -d ' \r')
  VERSION_CODE=$(sed -n '2p' "$VERSION_FILE" | tr -d ' \r')
else
  VERSION="0.0.0"
  VERSION_CODE="0"
fi

# Parse version
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"
MAJOR=${MAJOR:-0}
MINOR=${MINOR:-0}
PATCH=${PATCH:-0}
VERSION_CODE=${VERSION_CODE:-0}

# Calculate new version
case "$BUMP_TYPE" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_VERSION_CODE=$((VERSION_CODE + 1))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Version Bump: $VERSION → $NEW_VERSION ($BUMP_TYPE)"
echo "📱 Version Code: $VERSION_CODE → $NEW_VERSION_CODE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Update version.txt
echo "$NEW_VERSION" > "$VERSION_FILE"
echo "$NEW_VERSION_CODE" >> "$VERSION_FILE"
echo "✅ Updated version.txt"

# Update Android build.gradle
if [ -f "$GRADLE_FILE" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    #sed -i '' "s/versionCode [0-9]*/versionCode $NEW_VERSION_CODE/" "$GRADLE_FILE"
    #sed -i '' "s/versionName \"[0-9.]*\"/versionName \"$NEW_VERSION\"/" "$GRADLE_FILE"
    sed -i '' "s/platformVersion = \"[0-9.]*\"/platformVersion = \"$NEW_VERSION\"/" "$GRADLE_FILE"
  else
    # Linux
    #sed -i "s/versionCode [0-9]*/versionCode $NEW_VERSION_CODE/" "$GRADLE_FILE"
    #sed -i "s/versionName \"[0-9.]*\"/versionName \"$NEW_VERSION\"/" "$GRADLE_FILE"
    sed -i "s/platformVersion = \"[0-9.]*\"/platformVersion = \"$NEW_VERSION\"/" "$GRADLE_FILE"
  fi
  echo "✅ Updated build.gradle (versionCode, versionName, platformVersion)"
else
  echo "❌ build.gradle not found at: $GRADLE_FILE"
  exit 1
fi

echo ""
echo "🎉 Version bump complete!"
echo ""