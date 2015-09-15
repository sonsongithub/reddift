Pod::Spec.new do |s|
  s.name             = "reddift"
  s.version          = "1.3"
  s.summary          = "Swift Reddit API Wrapper."
  s.description      = <<-DESC
                      reddift is Swift Reddit API Wrapper.

                       - Supports OAuth2(and DOES NOT support Cookie-authentication).
                       - Supports multi-accounts using KeyChain.
                       DESC
  s.homepage         = "https://github.com/sonsongithub/reddift"
  s.license          = 'MIT'
  s.author           = { "sonson" => "yoshida.yuichi@gmail.com" }
  s.source           = {
    :git => "https://github.com/sonsongithub/reddift.git",
    :tag => "v#{s.version}",
    :submodules => true
  }

  s.subspec 'KeychainAccess' do |ka|
    ka.source_files = 'reddift/vendor/KeychainAccess/Lib/KeychainAccess/Keychain.swift'
  end

  s.social_media_url = 'https://twitter.com/sonson_twit'

  s.ios.deployment_target = "8.4"
  s.osx.deployment_target = "10.9"
  s.requires_arc = true

  s.source_files = 'reddift/*/*.swift'
end
