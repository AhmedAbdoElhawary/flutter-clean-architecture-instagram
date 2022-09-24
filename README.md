# flutter-clean-architecture-instagram

Instagram clean architecture using flutter and firebase as ( frontend & backend ) with almost all functionalities

### Notes 
* I didn't publish the keys such as messaging, agora, firebase web, or even google-services.json. So follow the steps (3. Setup the app) to add them.

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
      * View all likes on a comment & replay & their profiles
  * Edit post
  * Delete post
  * Unfollow the user of the post

* My Timelines Screen
  * Custom posts & stories feed based on followers & followings
  * Refresh the posts info
  * Loading more posts (it displays five by five posts)

* All Timelines Screen
  * View all user's posts (images & videos)
  * Change screen from a grid layout to a timeline layout

* Search for a user based on username

* Video Screen 
  * It displays all user's videos with almost post features
  * Control of sound & play
  
* Profile Screen
  * Follow / Unfollow Users
  * Display images & videos in a separate view
  * Change screen from a grid layout to a timeline layout
  * Edit profile info
  
* Chat Screen
  * Chat with any user
  * Support
    * Text
    * Image (gallery & camera)
    * Voice
    
#### New features
* Push Notificaitons
* Calling video in chat
* Send post to chats

## SnapShots

### |--------- Login page ----------|----------- Stories ------------|---------- List of posts ------- |

<p>
<img src="https://user-images.githubusercontent.com/88978546/173256887-3e3df39a-bc7e-4b9e-9568-92eefe64aed4.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257036-a5eca476-a302-4bd7-bfdf-9176f8100d9d.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257869-8a652a56-ef8e-4a7a-b28a-153a6db746a5.gif"   width="32%" height="50%">
</p>
 
### |----- Likes & Comment ------|-------- Edit the post ---------|--- All user timeline posts --- |
<p>
<img src="https://user-images.githubusercontent.com/88978546/173257119-4006f644-4fcf-43c1-9a4a-3255afcf0db5.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257164-9fc3b546-e940-4496-86c0-2e31b31f2c61.gif"  width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257889-a50b2613-b1a6-4aaf-a181-d8f422107c2f.gif"   width="32%" height="50%">
</p>

### |----- Search about user -----|--------- Videos page ---------|---- personal profile page --- |
<p>
<img src="https://user-images.githubusercontent.com/88978546/173257177-46c9a927-b269-4aac-8aad-d449b51b455f.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257900-43ff2295-06bd-4193-b6cc-a8dd34fb66ff.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257186-613a59c8-d5cc-40a1-b3aa-82c4545eb3a9.gif"   width="32%" height="50%">
</p>

### |----- Edit personal info ------|-- Selecting image for post --|-- Selecting image for story - |

<p>
<img src="https://user-images.githubusercontent.com/88978546/173257199-1a0152a0-ff20-4479-b51c-f9f329726a12.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257920-85816932-5da7-47e2-a318-e84696d75879.gif"  width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257206-d78fa66e-6295-4ede-a46e-7e94f943cd02.gif"   width="32%" height="50%">
</p>

### |---- Change app theme -----|--- Change app language ----| Chatting with bottom video |

<p>
<img src="https://user-images.githubusercontent.com/88978546/173257217-e8fabbf2-ce9d-460c-84ae-57057895bdfd.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257225-ccfc0561-eee2-4c26-ad5f-a94e22da108a.gif"   width="32%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/173257249-3aef7bd3-8174-45ce-9af9-73696ff20c8d.gif"   width="32%" height="50%">
</p>

### |-- Chatting with top video --|

<p>
<img src="https://user-images.githubusercontent.com/88978546/173257255-4fdd1318-3e21-47e4-bc4b-3f3809dc5b9c.gif"   width="32%" height="50%">
</p>

## Getting started

#### 1. [Setup Flutter](https://flutter.io/setup/)

#### 2. Clone the repo

```sh
$ git clone https://github.com/AhmedAbdoElhawary/flutter-clean-architecture-instagram
$ cd flutter-clean-architecture-instagram/
```

## 3. Setup the app

### . Setup the firebase services


1. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
2. Once your Firebase instance is created, you'll need to enable Email/Password authentication.

* Go to the Firebase Console for your new instance.
* Click "Authentication" in the left-hand menu
* Click the "sign-in method" tab
* Click "Email/Password" and enable it

4. Enable the Cloud Firestore
* Go to the Firebase Console
* Click "Firebase Database" in the left-hand menu
* Click on the "Create Database" button
* Select "Start in production mode" and "Enable"

5. Enable the Firebase Storage
* Go to the Firebase Console
* Click "Storage" in the left-hand menu
* Click on the "Create Storage" button
* Select "Start in production mode" and "Enable"


6. Add a Flutter app with firebase

* Recently google add to the firebase method to connect with your flutter app directly without making android and ios separately.
* Click "Project Overview" in the left-hand menu
* Click on the flutter icon button
* Just follow the steps carefully
* When you run flutterfire configure --project=^project name^ support android, ios, and web

5. Enable the Firebase Messaging
* Go to the Firebase Console
* Click "Messaging" in the left-hand menu
* Click on the android icon button
* Click on create your first campaign
* Now go to project settings and cloud Messaging and copy the server key in Cloud Messaging API
* Search for notificationKey in this project by a tap on control+shift+f in the IDE and set the server key as a string like this "key=^server key^" 

### . Setup agora
* Go to https://www.agora.io/en/ and sign in
* Go to console by clicking on the account icon
* Click on Project Management in the left-hand menu
* Click on Create New Project

* Now the most important step in the agora
  * Select "Testing mode: APP ID" not "secured mode" (if you select secured mode, It will be one channel available and you can't make another one in your app. in other words you can't make a private channel between two users or more, all users that use your app will go to the same calling room)

*  Set project name and Social/Chatroom in Use Case and click on submit

* Click on config on the project and copy App ID

* Search about agoraAppId in this project by a tap on control+shift+f in the IDE and set the App ID as a string
 

## What's Next?
 - [x] Notifications for likes, comments, follows, etc
 - [x] Caching of Profiles, Images, Etc.
 - [x] Calling video and voice in chat
 - [ ] Add stickers on chat
 - [x] Send posts to chats
 - [x] control in the dimension of selected image & video from the gallery
 - [x] Custom gallery display
 - [x] Improve display loading of posts when opening the app
 - [ ] Turn off commenting on a post
 - [ ] Hide Like count of a post
 - [x] share post
 - [x] Make like, comment, and share of animation container post touchy when long pressed on post
 - [ ] Create store screens
 - [ ] Make it stable for web & desktop
 - [ ] Clean-up more code



## How to Contribute
1. Fork the project
2. Create your feature branch (git checkout -b my-new-feature)
3. Make required changes and commit (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contact

You will find me on 

<a href="https://www.linkedin.com/in/ahmedabdoelhawary/"><img src="https://user-images.githubusercontent.com/35039342/55471530-94b34280-5627-11e9-8c0e-6fe86a8406d6.png" width="60"></a>


## License & Copyright

Copyright (c) 2022 Ahmed Abdo

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](LICENSE)
