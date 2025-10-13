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
            url:"https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.3/MyChipsSdk.xcframework.zip",
            checksum: "26a488303ac0d376bb096a6808c44060d65eacec2d424e687f1873114fd3ded1"
        )
    ]
)
