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
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "MyChipsSdk",
            url: "https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.0/MyChipsSdk.xcframework.zip",
            checksum: "210436eed0731a65e19738fa865da40659ddcf76bec721bca9f7a7e515b88868"
        )
    ]
)
