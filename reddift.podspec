Pod::Spec.new do |s|
  s.name             = "reddift"
  s.version          = "2.0.3"
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
    :tag => "#{s.version}",
    :submodules => true
  }

  s.social_media_url = 'https://twitter.com/sonson_twit'

  s.ios.deployment_target = "8.4"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.2"
  s.requires_arc = true

  s.source_files = [
    'framework/*/*.swift'
  ]
  s.dependency 'HTMLSpecialCharacters'
  s.dependency 'MiniKeychain'
end
