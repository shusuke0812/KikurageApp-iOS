// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageAnalytics",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "KALogger", targets: ["KALogger"]),
        .library(name: "KACrashlytics", targets: ["KACrashlytics"]),
        .library(name: "KAAnalytics", targets: ["KAAnalytics"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.15.0"))
    ],
    targets: [
        .target(
            name: "KALogger",
            path: "Sources/KALogger"
        ),
        .target(
            name: "KACrashlytics",
            dependencies: [
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/KACrashlytics"
        ),
        .target(
            name: "KAAnalytics",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/KAAnalytics"
        )
    ]
)
