# reddift
reddift is API wrapper for swift(for iOS).
reddift supports OAuth2 and DOES NOT support Cookie-authentication.

## How to build

Now, it's under developing.
You have to pay attention to use this library.

#### 1. Create application(installed app) at reddit.com

Check app's cliend_id and fill out redirect URI for OAuth2.

![reddit](https://cloud.githubusercontent.com/assets/33768/7277633/0b10bf0e-e94c-11e4-99c1-dbfcb0a2dcb3.png)

#### 2. Set up ````reddift_config.json````

Rename ````reddift_config.json.sample```` to ````reddift_config.json````.
And fill out "DeveloperName", "redirect_uri" and "client_id". "redirect_uri" must be same one you registered at reddit.com. You can check "client_id" at application tab.

    {
      "DeveloperName": "<YOUR NAME>",
      "redirect_uri": "<YOUR REDIRECT URI>",
      "client_id": "<YOUR ID>"
    }

#### 3. Set up your URI

In Xcode, register "URL Type" which uses "redirect_uri".

![reddit2](https://cloud.githubusercontent.com/assets/33768/7277677/52a1d1f0-e94c-11e4-9125-18c3acf13c0b.png)
  
## Dependency

reddift depends on [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) for saving access tokens.

## License

MIT License.
