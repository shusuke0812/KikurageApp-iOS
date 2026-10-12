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
        .library(name: "KSAppService", targets: ["KSAppService"]),
        .library(name: "KSLoginService", targets: ["KSLoginService"]),
        .library(name: "KSDeviceRegisterService", targets: ["KSDeviceRegisterService"]),
        .library(name: "KSHomeService", targets: ["KSHomeService"]),
        .library(name: "KSCultivationService", targets: ["KSCultivationService"]),
        .library(name: "KSRecipeService", targets: ["KSRecipeService"]),
        .library(name: "KSCalendarService", targets: ["KSCalendarService"]),
        .library(name: "KSDictionaryService", targets: ["KSDictionaryService"]),
    ],
    dependencies: [
        .package(path: "../KikurageDomain"),
        .package(path: "../KikurageAnalytics"),
        .package(path: "../KikurageUI"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.9.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.15.0")),
    ],
    targets: [
        .target(
            name: "KSAppService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .product(name: "KALogger", package: "KikurageAnalytics"),
                .product(name: "KACrashlytics", package: "KikurageAnalytics"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .target(name: "KSSLoadKikurageStateUseCase")
            ],
            path: "Sources/Services/KSAppService"
        ),
        .target(
            name: "KSLoginService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .target(name: "KSSLoadKikurageStateUseCase")
            ],
            path: "Sources/Services/KSLoginService"
        ),
        .target(
            name: "KSDeviceRegisterService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSDeviceRegisterService"
        ),
        .target(
            name: "KSHomeService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "RxSwift", package: "RxSwift"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSHomeService"
        ),
        .target(
            name: "KSCultivationService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .product(name: "KUIKit", package: "KikurageUI"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSCultivationService"
        ),
        .target(
            name: "KSRecipeService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSRecipeService"
        ),
        .target(
            name: "KSCalendarService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KDLoginManager", package: "KikurageDomain"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSCalendarService"
        ),
        .target(
            name: "KSDictionaryService",
            dependencies: [
                .product(name: "KDRepository", package: "KikurageDomain"),
                .product(name: "KDEntity", package: "KikurageDomain"),
                .product(name: "KUIKit", package: "KikurageUI"),
                .target(name: "KSSDateHelper")
            ],
            path: "Sources/Services/KSDictionaryService"
        ),
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
