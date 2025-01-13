// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KUIKit",
            targets: ["KUIKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.6.0")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/mac-cain13/R.swift", from: "7.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KUIKit",
            dependencies: [
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "kingfisher"),
                .product(name: "RswiftLibrary", package: "R.swift")
            ],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
        ),
        .testTarget(
            name: "KikurageUITests",
            dependencies: ["KUIKit"]
        ),
    ]
)
