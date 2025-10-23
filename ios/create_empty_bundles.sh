#!/bin/bash

# Create empty privacy bundle directories to prevent build errors
# These bundles need to be in their specific pod directories

BUNDLES=(
  "sqflite_darwin/sqflite_darwin_privacy.bundle"
  "shared_preferences_foundation/shared_preferences_foundation_privacy.bundle"
  "path_provider_foundation/path_provider_foundation_privacy.bundle"
  "nanopb/nanopb_Privacy.bundle"
  "leveldb-library/leveldb_Privacy.bundle"
  "image_picker_ios/image_picker_ios_privacy.bundle"
  "PromisesObjC/FBLPromises_Privacy.bundle"
  "GTMSessionFetcher/GTMSessionFetcher_Core_Privacy.bundle"
  "GoogleUtilities/GoogleUtilities_Privacy.bundle"
)

for bundle_path in "${BUNDLES[@]}"; do
  full_path="${BUILT_PRODUCTS_DIR}/${bundle_path}"
  mkdir -p "$full_path"

  # Create dummy Info.plist file
  cat > "$full_path/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleIdentifier</key>
    <string>com.placeholder.bundle</string>
</dict>
</plist>
EOF
done

exit 0
