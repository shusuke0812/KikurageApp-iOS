// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppService",
            targets: ["AppService"]
        ),
    ],
    dependencies: [
        .package(path: "../KikurageDomain")
    ],
    targets: [
        .target(
            name: "AppService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/AppService"
        ),
        // MARK: - Features
        .target(
            name: "KSFeatures",
            dependencies: []
        ),
    ]
)
