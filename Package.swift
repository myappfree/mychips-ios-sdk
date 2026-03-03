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
            url:"https://github.com/myappfree/mychips-ios-sdk/releases/download/v1.0.5/MyChipsSdk.xcframework.zip",
            checksum: "059f645f3d7cef5d42affc2942bf353b59fff54b9106cb7df117373a8593561f"
        )
    ]
)
