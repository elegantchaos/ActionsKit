// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ActionsKit",
    platforms: [
        .macOS(.v10_13), .iOS(.v12),
    ],
    products: [
        .library(
            name: "ActionsKit",
            targets: ["ActionsKit"]),
    ],
    dependencies: [
         .package(url: "https://github.com/elegantchaos/Actions", from: "1.3.5"),
    ],
    targets: [
        .target(
            name: "ActionsKit",
            dependencies: ["Actions"]),
        .testTarget(
            name: "ActionsKitTests",
            dependencies: ["ActionsKit"]),
    ]
)
