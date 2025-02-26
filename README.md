# iOS Deep Link SDK

A Swift package for iOS applications that allows easy integration with web content and provides deep linking capabilities.

## Features

- Load hosted web content within your iOS application
- Handle custom URL schemes for deep linking
- Easily navigate between web and native screens
- Simple API for quick integration

## Installation

### Swift Package Manager

Add the following dependency to your Package.swift file:

```swift
dependencies: [
    .package(url: "path/to/your/repo/IOSDeepLinkSDK.git", from: "1.0.0")
]
```

Or in Xcode, go to File > Add Packages... and enter the repository URL.

## Usage

### Basic Setup

```swift
import IOSDeepLinkSDK
import SwiftUI

struct ContentView: View {
    @State private var showWebView = false
    
    var body: some View {
        VStack {
            // Create a button that will launch the web content
            IOSDeepLinkSDK.shared.createLaunchButton(label: "Open Web App") {
                showWebView = true
            }
        }
        .sheet(isPresented: $showWebView) {
            // Present the web content in a sheet
            IOSDeepLinkSDK.shared.createWebView { deepLinkType in
                // Handle deep links
                switch deepLinkType {
                case .test:
                    // Show the test view
                    showWebView = false
                    // Navigate to your test screen
                
                case .unknown(let url):
                    print("Unknown URL: \(url)")
                }
            }
        }
    }
}
```

### Custom Configuration

You can configure the SDK with a custom URL:

```swift
// In your AppDelegate or early in your app's lifecycle
IOSDeepLinkSDK.shared.configure(webUrl: URL(string: "https://your-custom-url.com")!)
```

## License

[Your License Information]
