// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "IOSDeepLinkSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "IOSDeepLinkSDK",
            targets: ["IOSDeepLinkSDK"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "IOSDeepLinkSDK",
            dependencies: []),
        .testTarget(
            name: "IOSDeepLinkSDKTests",
            dependencies: ["IOSDeepLinkSDK"]),
    ]
)
