// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Smarkdown",
    products: [
        .library(
            name: "Smarkdown",
            targets: ["Smarkdown"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Smarkdown",
            dependencies: []),
        .testTarget(
            name: "SmarkdownTests",
            dependencies: ["Smarkdown"]),
    ]
)
