// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageDomain",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "KDRepository",
            targets: ["KDRepository"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.6.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "KDRepository",
            dependencies: [
                .target(name: "KDFirebase"),
                .target(name: "KDRestApi"),
                .product(name: "RxSwift", package: "RxSwift")
            ],
            path: "Sources/KDRepository"
        ),
        // MARK: - Infrastructure
        .target(
            name: "KDFirebase",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "Sources/Infrastructure/KDFirebase",
            resources: [
                .process("Sources/Resources")
            ]
        ),
        .target(
            name: "KDRestApi",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift")
            ],
            path: "Sources/Infrastructure/KDRestApi",
            resources: [
                .process("Sources/Resources")
            ]
        ),
        .target(
            name: "KDBluetooth",
            path: "Sources/Infrastructure/KDBluetooth"
        )
    ]
)
