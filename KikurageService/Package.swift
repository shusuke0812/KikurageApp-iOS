// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KikurageService",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "KSAppService", targets: ["KSAppService"]),
        .library(name: "KSLoginService", targets: ["KSLoginService"]),
        .library(name: "KSSignUpService", targets: ["KSSignUpService"]),
        .library(name: "KSDeviceRegisterService", targets: ["KSDeviceRegisterService"]),
        .library(name: "KSHomeService", targets: ["KSHomeService"]),
        .library(name: "KSCultivationService", targets: ["KSCultivationService"]),
        .library(name: "KSRecipeService", targets: ["KSRecipeService"]),
        .library(name: "KSCalendarService", targets: ["KSCalendarService"]),
        .library(name: "KSGraphService", targets: ["KSGraphService"]),
        .library(name: "KSAccountSettingService", targets: ["KSAccountSettingService"]),
        .library(name: "KSDictionaryService", targets: ["KSDictionaryService"]),
        .library(name: "KSWiFiService", targets: ["KSWiFiService"]),
        .library(name: "KSDebugService", targets: ["KSDebugService"]),
    ],
    dependencies: [
        .package(path: "../KikurageDomain"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
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
        .target(
            name: "KSHomeService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "Sources/Services/KSHomeService"
        ),
        .target(
            name: "KSCultivationService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSCultivationService"
        ),
        .target(
            name: "KSRecipeService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSRecipeService"
        ),
        .target(
            name: "KSCalendarService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSCalendarService"
        ),
        .target(
            name: "KSGraphService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ],
            path: "Sources/Services/KSGraphService"
        ),
        .target(
            name: "KSAccountSettingService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ],
            path: "Sources/Services/KSAccountSettingService"
        ),
        .target(
            name: "KSDictionaryService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSDictionaryService"
        ),
        .target(
            name: "KSWiFiService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .target(name: "KSFeatures")
            ],
            path: "Sources/Services/KSWiFiService",
            resources: [
                .process("../../Resources")
            ]
        ),
        .target(
            name: "KSDebugService",
            dependencies: [],
            path: "Sources/Services/KSDebugService"
        ),
        // MARK: - Features
        .target(
            name: "KSFeatures",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
