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
            url:"https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.0/MyChipsSdk.xcframework.zip",
            checksum: "d8faa564b6f5940ffd9f6c07415c6edb3ac578e86a3edb4bee2582fa0fa9956d"
        )
    ]
)
