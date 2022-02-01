# ApodNasaApi
This project is created as part of the exercise is to create a mobile app that helps with displaying NASA’s Astronomy picture of the day
<div align="center">
        <img width="45%" src="https://user-images.githubusercontent.com/65060903/151961967-f0fa8e1e-00c3-40e0-ab0f-56e8bf082809.png"</img>
</div>

## Features
•    Allow users to search for the picture for a date of their choice
•    Display date, explanation, Title and the image / video of the day
•    Cache information and display last updated information in case of 
network unavailability.
•    Dark mode support
•    Handle different screen sizes, orientations

## Requirements
- iOS 13 or above
- Xcode 12 or above
- Swift 5.0+

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
Then, run the following command:

```bash
$ pod install
```

## Dependency
```
pod 'ProgressHUD'
pod 'SDWebImage'
```

## References

NASA’s open APIs ( https://api.nasa.gov/ ) and in particular, the APOD ( Astronomy picture of the day ) resource. 

## License

MIT
