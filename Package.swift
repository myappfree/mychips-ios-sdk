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
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .binaryTarget(
            name: "MyChipsSdk",
            url: "https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.0/MyChipsSdk.xcframework.zip",
            checksum: "d16224bed7c17d630e524c6d2a6d78196ad165380b64e420de6f922a0e1e9154"
        )
    ]
)
