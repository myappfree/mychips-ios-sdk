// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyChipsSdk",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MyChipsSdk",
            targets: ["MyChipsSdk"]),
    ],
    targets: [
        .binaryTarget(
            name: "MyChipsSdk",
            url:"https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.4/MyChipsSdk.xcframework.zip",
            checksum: "7e43ac7504c5a3914e79e452fc8c2e770e98f34e66b6e795393ab3dfabace8c3"
        )
    ]
)
