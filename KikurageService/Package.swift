// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageService",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
    ],
    dependencies: [
        .package(path: "../KikurageDomain"),
        .package(path: "../KikurageAnalytics"),
        .package(path: "../KikurageUI"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.9.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.15.0")),
    ],
    targets: [
        // MARK: - SharedServices

        .target(
            name: "KSSLoadKikurageStateUseCase",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ],
            path: "Sources/SharedServices/KSSLoadKikurageStateUseCase"
        ),
        .target(
            name: "KSSDateHelper",
            path: "Sources/SharedServices/KSSDateHelper"
        ),
    ]
)
