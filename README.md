[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/reddift.svg?style=flat)](http://cocoadocs.org/docsets/reddift)
[![License](https://img.shields.io/cocoapods/l/reddift.svg?style=flat)](http://cocoadocs.org/docsets/reddift)
[![Platform](https://img.shields.io/cocoapods/p/reddift.svg?style=flat)](http://cocoadocs.org/docsets/reddift)

# reddift
reddift is API wrapper for swift(for iOS).

 * Supports OAuth2(and DOES NOT support Cookie-authentication).
 * Supports multi-accounts.
 * Includes a sample application(iOS only).

![sc02](https://cloud.githubusercontent.com/assets/33768/7570674/e68381c0-f84c-11e4-914b-532f9fd06e19.png)　
![sc01](https://cloud.githubusercontent.com/assets/33768/7570673/e653f39c-f84c-11e4-98c7-2c3e9ef872ad.png)

## How to build

Now, it's under developing.
You have to pay attention to use this library.

#### 1. Create application(installed app) at reddit.com

Create new installed app via preference page at reddit.com.
And then, check your app's cliend_id and fill out redirect URI for OAuth2.

![installedapp](https://cloud.githubusercontent.com/assets/33768/7569703/7aa0cd84-f845-11e4-8860-2c953c9522a2.png)

#### 2. Set up ````reddift_config.json````

This JSON file saves application information to use OAuth.
Rename ```reddift_config.json.sample``` to ```reddift_config.json```.
And fill out ```DeveloperName```, ```redirect_uri``` and ```client_id```. 
```redirect_uri``` must be same one you registered at reddit.com.
You can check ```client_id``` at application tab.
reddift generates http's user-agent property using this JSON.

    {
      "DeveloperName": "<YOUR NAME>",
      "redirect_uri": "<YOUR REDIRECT URI>",
      "client_id": "<YOUR ID>"
    }

#### 3. Set up your URI on Xcode

In Xcode, register ```URL Type``` which uses ```redirect_uri``` in order to receive call back from Safari.
These URI must be identical.
If they are not identical, reddit.com does not authorize your OAuth request.

![reddit2](https://cloud.githubusercontent.com/assets/33768/7277677/52a1d1f0-e94c-11e4-9125-18c3acf13c0b.png)

## Getting started

    session?.getList(paginator, sort:sortType, subreddit:subreddit, completion: { (result) in
        switch result {
        case let .Failure:
            println(result.error)
        case let .Success:
            println(result.value)
            if let listing = result.value as? Listing {
                for obj in listing.children {
                    if let link = obj as? Link {
                        self.links.append(link)
                    }
                }
                self.paginator = listing.paginator
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.loading = false
            })
        }
    })

## How to build test

#### 1. Register user script app

Test uses Application Only OAuth to remove user interaction from test process.
If you want to test reddift, you have to create another "Script" type application(personal use script) at reddit.com.

![userscript](https://cloud.githubusercontent.com/assets/33768/7569704/7ad7bf10-f845-11e4-8e10-89487a65d5d4.png)

#### 2. Build libraries

Test depends on [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble).
You may build them using [Carthage](https://github.com/Carthage/Carthage) ver easy.
You could install and setup Carthage using Installer or Homebrew.
reddift include Cartfile for Carthage.
So, you build it with the following command.

    > carthage update
    
#### 3. Fill out ````test_config.json````

At first, rename ````test_config.json.sample```` to ````test_config.json````.
Fill each following value using above preference pain of reddit.com.

    {
      "username": "test user account",
      "password": "test user password",
      "client_id": "test app client ID(must be script type app)",
      "secret": "test app secret"
    }

## Dependency

* reddift depends on [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) for saving access tokens.
* Sample application depends on [UZTextView](https://github.com/sonsongithub/UZTextView.git).
* Test depends on [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble).

## License

MIT License.
