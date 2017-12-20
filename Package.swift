// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "benderbot",
    products: [
        .library(name: "BenderBot", targets: ["BenderBot"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(name: "BenderBot", dependencies: ["Vapor", "FluentProvider"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["BenderBot"]),
        .testTarget(name: "AppTests", dependencies: ["BenderBot", "Testing"])
    ]
)
