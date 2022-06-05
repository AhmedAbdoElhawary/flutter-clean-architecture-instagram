# flutter-clean-architecture-instagram

Instagram with clean architecture using flutter and firebase as ( frontend & backend )

## Note 

This repository and "documentation" are still under development.

## Features

* Support
  * Arabic & English language
  * Dark & Light theme 

* Post features
  * Support images & videos 
  * Support multi images in one post
  * Like on a post 
    * View all likes on a post and their profiles
  * Comment on a post 
    * View all comments on a post
    * Replay on a comment & replay 
    * Like on a comment & replay
      * View all likes on a comment & replay and their profiles
  * Edit post
  * Delete post
  * Unfollow the user of the post

* My Timelines Screen
  * Custom posts & stories feed based on followers & followings
  * Refresh the posts info
  * Loading more posts (it displays 5 by 5 posts)

* All Timelines Screen
  * View all users posts (images & videos)
  * Change screen from grid layout to timeline layout

* Search for user based on username

* Video Screen 
  * It displays all users videos with almost post features
  * Control of sound & play
  
* Profile Screen
  * Follow / Unfollow Users
  * Display images & videos in a separated view
  * Change screen from grid layout to timeline layout
  * Edit profile info
  
* Chat Screen
  * Chat with any user
  * Support
    * Text
    * Image (gallery & camera)
    * Voice
## SnapShots
* soon
* I have some bad user experiences and bugs trying to improve,
* then, I will publish snapshots of this huge project
## Getting started

#### 1. [Setup Flutter](https://flutter.io/setup/)

#### 2. Clone the repo

```sh
$ git clone https://github.com/AhmedAbdoElhawary/flutter-clean-architecture-instagram
$ cd flutter-clean-architecture-instagram/
```

#### 3. Setup the firebase app

1. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
2. Once your Firebase instance is created, you'll need to enable anonymous authentication.

* Go to the Firebase Console for your new instance.
* Click "Authentication" in the left-hand menu
* Click the "sign-in method" tab
* Click "Google" and enable it


4. Enable the Firebase Database
* Go to the Firebase Console
* Click "Database" in the left-hand menu
* Click the Cloudstore "Create Database" button
* Select "Start in test mode" and "Enable"

5. (skip if not running on Android)

* Create an app within your Firebase instance for Android, with package name com.ahmed.instagram
* Run the following command to get your SHA-1 key:

```
keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```

* In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
* Follow instructions to download google-services.json
* place `google-services.json` into `/android/app/`.


6. (skip if not running on iOS)

* Create an app within your Firebase instance for iOS, with your app package name
* Follow instructions to download GoogleService-Info.plist
* Open XCode, right click the Runner folder, select the "Add Files to 'Runner'" menu, and select the GoogleService-Info.plist file to add it to /ios/Runner in XCode
* Open /ios/Runner/Info.plist in a text editor. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist

Double check install instructions for both
   - Google Auth Plugin
     - https://pub.dartlang.org/packages/firebase_auth
   - Firestore Plugin
     -  https://pub.dartlang.org/packages/cloud_firestore


## What's Next?
 - [ ] Notificaitons for likes, comments, follows, etc
 - [ ] Caching of Profiles, Images, Etc.
 - [ ] Calling video and voice in chat
 - [ ] Add stickers on chat
 - [ ] Send post to chats
 - [x] control in dimension of selected image & video from gallery
 - [x] Custom gallery display
 - [ ] Filters support for images
 - [x] Improve display loading of posts when open the app
 - [ ] Like & comment on story
 - [ ] Delete the story
 - [ ] Turn off commenting of a post
 - [ ] Hide Like count of a post
 - [ ] Archive a post
 - [ ] share post
 - [ ] Live support
 - [ ] Make like, comment and share of animation container post touchy when longPressed on post
 - [ ] Create store screens
 - [ ] Make it stable for web & desktop
 - [ ] Clean-up more code



## How to Contribute
1. Fork the the project
2. Create your feature branch (git checkout -b my-new-feature)
3. Make required changes and commit (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request


## Contact

You will find me on 

<a href="https://www.linkedin.com/in/ahmedabdoelhawary/"><img src="https://user-images.githubusercontent.com/35039342/55471530-94b34280-5627-11e9-8c0e-6fe86a8406d6.png" width="60"></a>


## License & copyright

Copyright (c) 2022 Ahmed Abdo

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](LICENSE)
