# SwiftyProxy

[![CI Status](https://img.shields.io/travis/samirGuerdah/SwiftyProxy.svg?style=flat)](https://travis-ci.org/samirGuerdah/SwiftyProxy)
[![Version](https://img.shields.io/cocoapods/v/SwiftyProxy.svg?style=flat)](https://cocoapods.org/pods/SwiftyProxy)
[![License](https://img.shields.io/cocoapods/l/SwiftyProxy.svg?style=flat)](https://cocoapods.org/pods/SwiftyProxy)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyProxy.svg?style=flat)](https://cocoapods.org/pods/SwiftyProxy)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

SwiftyProxy is written in **Swift 4.0** and supports **iOS 10.0** and later. SwiftyProxy doesn't intercept requests made by NSURLConnection.

## Installation

### CocoaPods

SwiftyProxy is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyProxy'
```

### Carthage

Add the following dependency to your `Cartfile`:

```none
github "samirGuerdah/SwiftyProxy"
```

## Usage example

The first step is to register the `URLSessionConfiguration` of the `URLSession` that you are using for your web servicers.

```objc
// Objective-C
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
[SwiftyProxy registerSessionConfiguration:configuration];
```

```swift
// Swift
let configuration = URLSessionConfiguration.default
SwiftyProxy.registerSessionConfiguration(configuration)
```

if you're using [AFNetworking](https://github.com/AFNetworking/AFNetworking)/[Alamofire](https://github.com/Alamofire/Alamofire), you should register the  `URLSessionConfiguration` first with SwiftyProxy :

```objc
// Objective-C (AFNetworking)
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
[SwiftyProxy registerSessionConfiguration:configuration];
AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
```

```swift
// Swift (Alamofire)
let configuration = URLSessionConfiguration.default
SwiftyProxy.registerSessionConfiguration(configuration)
let manager = Alamofire.SessionManager(configuration: configuration)
```

![SwiftyProxy](Assets/SwiftyProxy.gif)

## Author

Samir Guerdah, sguerdah@gmail.com

## License

SwiftyProxy is available under the MIT license. See the LICENSE file for more info.
