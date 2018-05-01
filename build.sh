echo "Create keychain"
# Create the keychain with a password
security create-keychain -p travis ios-build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Add certificates to keychain and allow codesign to access them
security import ./Provisioning/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k travis ios-build.keychain

echo "Build start"
xcodebuild test -project reddift.xcodeproj -scheme reddift-iOS -configuration Debug -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 8"
