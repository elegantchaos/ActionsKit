// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ActionsKit",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "ActionsKit",
            targets: ["ActionsKit"]),
    ],
    dependencies: [
         .package(url: "https://github.com/elegantchaos/Actions", from: "1.5.1"),
         .package(url: "https://github.com/elegantchaos/Logger", from: "1.5.3"),
         .package(url: "https://github.com/elegantchaos/Localization", from: "1.0.3"),
    ],
    targets: [
        .target(
            name: "ActionsKit",
            dependencies: ["Actions", "Localization", "Logger", "LoggerKit"]),
        .testTarget(
            name: "ActionsKitTests",
            dependencies: ["ActionsKit"]),
    ]
)
