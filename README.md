# reddift
reddift is API wrapper for swift(for iOS).
reddift supports OAuth2 and DOES NOT support Cookie-authentication.

### How to build

Now, it's under developing.
You have to pay attention to use this library.

1. Create application(installed app) at reddit.com.
2. Rename ````reddift_config.json.sample```` to ````reddift_config.json````.
3. Fill out "DeveloperName", "redirect_uri" and "client_id". "redirect_uri" must be same one you registered at reddit.com. You can check "client_id" at application tab.
4. In Xcode, register "URL Type" which uses "redirect_uri".
5. Have fun.

### Dependency

reddift depends on [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) for saving access tokens.

### Support API Milestone

#### [version 0.1](https://github.com/sonsongithub/reddift/wiki/version0.1---Milestone)

1. listing
1. search
1. subreddits

#### [version 0.2](https://github.com/sonsongithub/reddift/wiki/version0.2-Milestone)

1. account
2. links & comments
3. multis

#### [Remainder](https://github.com/sonsongithub/reddift/wiki/Remainder)

### License

MIT License.
