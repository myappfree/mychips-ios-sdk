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
            url:"https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.1.0/MyChipsSdk.xcframework.zip",
            checksum: "cc337940d1f3c0906a2ee4aeeea4f4d4cfda8d57e15f9b95e20d53c497a90ee9"
        )
    ]
)
