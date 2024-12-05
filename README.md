**v3.0**

# iOS developer environment setup

Please follow the instructions in order of appearance as some steps depend on previous steps.

## Introduction

In order to install our projects we are using:  
- Git  
- Fastlane  
- Cocoapods  
- Bundle
- R.swift  

See also [Valley insights Architecture](https://docs.google.com/document/d/1Vmus05qhnXW8PPkIoYVOcgnahHG_rRmB4UlVQ6_yxFE/edit?usp=sharing)


# <u>Installation</u>

## Git

Git is a version control system (VCS) for tracking changes in computer files and coordinating work on those files among multiple people. It is primarily used for software development.

To install Git : [Git](https://formulae.brew.sh/formula/git)  
First created an SSH key on your local machine, Add it on your Bitbacket account under Personal settings -> SSH keys , and cloned the iOS project to your local machine from Bitbacket using SSH
To generate SSH : [Generate SSH Mac](https://www.siteground.com/kb/how_to_generate_an_ssh_key_pair_in_mac_os/)
Tip: use sudo when you add the ssh to your mac (sudo ssh-add -K id_rsa)


## Fastlane

Fastlane is a tool for iOS, Mac, and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.



## CocoaPods 

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. It has over 31 thousand libraries and is used in over 2 million apps.


## Bundle
Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed.
Bundle is part of ruby in you mac

# <u>Getting started</u>

## 1. Bundle

Navigate to the openfields-ios project root directory (the one with the gemfile and podfile)
Install all gems from the project gemfile: `$ bundle install`, it will install all dependecies above and more.


## 2. Cocoapods

In order to install all packages for the project please run - `$ bundle e pod install`

## 3. Fastlane match (Optional)

Fastlane Match allows you to share one code signing identity across your development team to simplify your codesigning setup and prevent code signing issues. Match creates all required certificates & provisioning profiles and stores them in a separate Git repository. Every team member with access to the repo can use those credentials for code signing.
Git repository: (https://bitbucket.org/prosperaag/valley-insights-ios-match)

**IMPORTANT!!**: please don't clone the repo directly! Fastlane will do it for you like so:
Run -  `$ bundle e fastlane update_developer_match`
This lane(fastlane script) will clone the repo and store all certificates for you.

For certificate passwords please talk to the administrator.

## 4. R.swift  

Some of our resources (like strings) are used by the R.swift machanisem [R.swift](https://github.com/mac-cain13/R.swift)
Before Compiling the project use this command - `$ bundle e fastlane generate_r_swift` . This command will generate all the assets types to use in the app. (You will have to run this command everytime you add a asset to the app).

**That's it, now you can build and start work :)**


## QA Analytics
1. Connet to Prospera VPN
2. Go to Screen **Sharing App** in your mac
3. insert - `ec2-18-206-95-15.compute-1.amazonaws.com` (password with the administrator)
4. open Iterms (please do not touch the terminal runners)
5. Run - `cd /Users/ec2-user/Desktop/QA/openfield-ios`
6. Run - `./qa-branch-script.sh`
7. open **Xcode** and choose **Openfield** located in **Desktop/QA/openfield-ios**

In order to run an Analytics debugging you need to choose **Analytics-debug** Scheme on Xcode.
then run the project on any simulator and you will be able to see the analytics in **Firebase Analytics Debug View**



