fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test_app

```sh
[bundle exec] fastlane ios test_app
```



### ios check_xcode

```sh
[bundle exec] fastlane ios check_xcode
```

check xcode version

### ios update_devices

```sh
[bundle exec] fastlane ios update_devices
```

update provisioning profile and update to local machine using devices.txt

### ios update_developer_match

```sh
[bundle exec] fastlane ios update_developer_match
```

fetch remote provisions into local machine and store in keychain

### ios renew_provisioning

```sh
[bundle exec] fastlane ios renew_provisioning
```

[CAUTION!!!] create new provisioning profiles on Apple Developer,
  sets them on remote and update local machine

### ios build_only

```sh
[bundle exec] fastlane ios build_only
```



### ios deploy_testflight_prod

```sh
[bundle exec] fastlane ios deploy_testflight_prod
```



### ios deploy_firebase_staging

```sh
[bundle exec] fastlane ios deploy_firebase_staging
```



### ios deploy_firebase_qa

```sh
[bundle exec] fastlane ios deploy_firebase_qa
```



### ios deploy_aws_staging

```sh
[bundle exec] fastlane ios deploy_aws_staging
```



### ios deploy_aws_qa

```sh
[bundle exec] fastlane ios deploy_aws_qa
```



### ios deploy_aws_prod

```sh
[bundle exec] fastlane ios deploy_aws_prod
```



### ios upload_to_s3

```sh
[bundle exec] fastlane ios upload_to_s3
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
