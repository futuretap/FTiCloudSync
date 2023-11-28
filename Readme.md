# FTiCloudSync
[![License](https://img.shields.io/badge/Platform-iOS-gray)](https://creativecommons.org/licenses/by-sa/4.0/)
[![License](https://img.shields.io/badge/License-CC--BY--SA_4.0-gray)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Sponsor](https://img.shields.io/badge/Sponsor-ff40a0)](https://github.com/sponsors/futuretap)
[![Mastodon](https://img.shields.io/mastodon/follow/000010558?domain=https%3A%2F%2Fmastodon.cloud)](https://mastodon.cloud/@ortwingentz)

Automatically syncs NSUserDefaults across multiple iOS devices using iCloud key-value storage (`NSUbiquitousKeyValueStore`).

## Installation
Drag all files into your Xcode project.


## Requirements
iCloud requires iOS 5.0 or later. If iCloud is not available, this code does nothing.


## Usage
All write and remove requests to NSUserDefaults are automatically synchronized with iCloud. To prevent synchronization for individual keys, prefix the key with a ! (exclamation mark).

To respond to updates from iCloud you can observe the `FTiCloudSyncDidUpdateNotification`. It contains the `NSUserDefaults` object and in the `userInfo` a dictionary with `FTiCloudSyncChangedKeys` and `FTiCloudSyncRemovedKeys`. These are arrays of the changed and removed keys.


## Compatibility
FTiCloudSync is compatible with [InAppSettingsKit](http://www.inappsettingskit.com), a framework to easily add in-app settings to iPhone apps. InAppSettingsKit automatically updates the UI when an iCloud update is received.


## Author
Developed by [Ortwin Gentz](https://www.futuretap.com/about/ortwin-gentz) ([Mastodon](https://mastodon.cloud/@ortwingentz)) and used in [FutureTap](https://www.futuretap.com)’s [Where To?](https://wheretoapp.com) and [Streets](https://streets.app) apps – we eat our own dog food!


## License
Licensed under [CC-BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/).

You are free to share, adapt and make commercial use of the work as long as you give attribution and keep this license. To give credit, we suggest this text in the about screen or App Store description: "Uses FTiCloudSync by Ortwin Gentz", with a link to the [GitHub page](https://github.com/futuretap/FTiCloudSync).

If you need a different license without attribution requirement, please contact me and we can work something out.

Includes:

- [RegexKitLite](http://regexkit.sourceforge.net/) by John Engelhart. Copyright &copy; 2008-2010 John Engelhart. Licensed under the terms of the BSD License.
- [MethodSwizzling](http://cocoadev.com/index.pl?MethodSwizzling) by Mike Ash

## Sponsors wanted
If you would like to support my Open Source work, consider joining me as a [sponsor](https://github.com/sponsors/futuretap)! 💪️ Your sponsorship enables me to spend more time on this and other community projects. Thank you!