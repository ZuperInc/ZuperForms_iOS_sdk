![SNHttpRequest: Networking in Swift](https://i.ibb.co/pRWFxt8/Screenshot-2020-02-15-at-11-30-58-PM.png)
![Version](https://img.shields.io/cocoapods/v/SNHttpRequest.svg?style=flat)


SNHttpRequest
=========

`SNHttpRequest` is a thin wrapper around `NSURLSession` in Swift to simplify HTTP requests.

## Requirements

- iOS 11.0+ 
- Xcode 10.2+
- Swift 5+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SNHttpRequest'
```

## Features

- Convenient Closure APIs
- Parameter Encoding
- Builtin JSON Request Serialization
- Concise Codebase.

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import SNHttpRequest
```

## Examples

### HTTP Methods

All the common HTTP methods are avalaible as convenience methods as well.

### GET

The most basic request. By default an Data object will be returned for the response.
```swift
RequestService.getRequest(url: "https://google.com") { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }
  
  RequestService.getRequest(url: "your endpoint", token: "your token", authType: .bearerToken) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }
    }
```

### POST

```swift
let postData = ["param1":"value1","param2":"value2"]
RequestService.postRequest(url: "your endpoint", postData: postData, method: .post) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }
        
 RequestService.postRequest(url: "your endpoint",token: "token",authType: .bearerToken, postData: postData, method: .post) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }

```

### PUT

```swift
let postData = ["param1":"value1","param2":"value2"]
RequestService.postRequest(url: "your endpoint", postData: postData, method: .put) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }
        
 RequestService.postRequest(url: "your endpoint",token: "token",authType: .bearerToken, postData: postData, method: .put) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }

```


### DELETE

```swift
let postData = ["param1":"value1","param2":"value2"]
RequestService.postRequest(url: "your endpoint", postData: postData, method: .delete) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }
        
 RequestService.postRequest(url: "your endpoint",token: "token",authType: .bearerToken, postData: postData, method: .delete) { (response) in
            switch response
            {
            case .Success(let response):
                print(response)
                
            case .ApiError(let apiError):
                print(apiError)
                
            case .Error(let error):
                print(error)
            }
        }

```
