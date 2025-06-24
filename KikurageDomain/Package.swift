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
        .library(name: "KDRepository", targets: ["KDRepository"]),
        .library(name: "KDLoginManager", targets: ["KDLoginManager"]),
        .library(name: "KDEntity", targets: ["KDEntity"]),
        .library(name: "KDBluetoothManager", targets: ["KDBluetoothManager"])
    ],
    dependencies: [
        .package(path: "../KikurageAnalytics"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.15.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.8.0"))
    ],
    targets: [
        .target(
            name: "KDRepository",
            dependencies: [
                .target(name: "KDFirebase"),
                .target(name: "KDRestApi"),
                .target(name: "KDEntity"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"), // TODO: Request型に定義したFirestoreの処理をInterceptorに移動したら削除する
            ],
            path: "Sources/KDRepository"
        ),
        .target(
            name: "KDLoginManager",
            dependencies: [
                .target(name: "KDFirebase"),
                .target(name: "KDLocalStore"),
                .target(name: "KDEntity")
            ],
            path: "Sources/KDLoginManager"
        ),
        .target(
            name: "KDEntity",
            dependencies: [
                .target(name: "KDFirebase"),
                .target(name: "KDRestApi"),
                .target(name: "KDLocalStore"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"), // TODO: Request型に定義したFirestoreの処理をInterceptorに移動したら削除する
            ],
            path: "Sources/KDEntity"
        ),
        .target(
            name: "KDBluetoothManager",
            dependencies: [
                .target(name: "KDBluetooth"),
                .product(name: "KALogger", package: "KikurageAnalytics")
            ],
            path: "Sources/KDBluetoothManager"
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
            path: "Sources/Infrastructure/KDFirebase"
        ),
        .target(
            name: "KDRestApi",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift")
            ],
            path: "Sources/Infrastructure/KDRestApi"
        ),
        .target(
            name: "KDBluetooth",
            path: "Sources/Infrastructure/KDBluetooth"
        ),
        .target(
            name: "KDLocalStore",
            path: "Sources/Infrastructure/KDLocalStore"
        )
    ]
)
