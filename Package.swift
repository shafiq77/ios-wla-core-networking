// swift-tools-version:5.1.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Theme",
            type: .dynamic,
            targets: ["Theme"]),
        .library(
            name: "NetworkServices",
            type: .dynamic,
            targets: ["NetworkServices"])
    ],
    dependencies: [
    ],
    targets: [
        // Theme framework
        .target(
            name: "Theme",
            dependencies: [],
            path: "./Sources/Theme"),
        // NetworkServices framework
        .target(
            name: "NetworkServices",
            dependencies: [],
            path: "./Sources/NetworkServices")
    ]
)
