// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomTabBarVC",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "CustomTabBarVC", targets: ["CustomTabBarVC"])
    ],
    targets: [
        .target(name: "CustomTabBarVC", path: "Sources")
    ]
)
