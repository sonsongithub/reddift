echo "Create keychain"
security create-keychain -p travis build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p travis build.keychain
security set-keychain-settings -t 3600 -l ~/Library/Keychains/build.keychain

# security import ./Lib/Certificates/apple.cer -k ~/Library/Keychains/build.keychain -T /usr/bin/codesign

echo "Build start"
xcodebuild test -project reddift.xcodeproj -scheme reddift-iOS -configuration Debug -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 8"
