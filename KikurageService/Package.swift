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
        .library(name: "KSAppService", targets: ["KSAppService"]),
        .library(name: "KSLoginService", targets: ["KSLoginService"]),
        .library(name: "KSSignUpService", targets: ["KSSignUpService"]),
        .library(name: "KSDeviceRegisterService", targets: ["KSDeviceRegisterService"])
    ],
    dependencies: [
        .package(path: "../KikurageDomain")
    ],
    targets: [
        .target(
            name: "KSAppService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSAppService"
        ),
        .target(
            name: "KSLoginService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSLoginService"
        ),
        .target(
            name: "KSSignUpService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ],
            path: "Sources/Services/KSSignUpService"
        ),
        .target(
            name: "KSDeviceRegisterService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
            ],
            path: "Sources/Services/KSDeviceRegisterService"
        ),
        // MARK: - Features
        .target(
            name: "KSFeatures",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ]
        ),
    ]
)
