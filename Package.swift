// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPhotoGallery",
    platforms: [
        .iOS(.v10), .tvOS(.v10)
    ],
    products: [
        .library(
            name: "SwiftPhotoGallery",
            targets: ["SwiftPhotoGallery"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.1.1"))
    ],
    targets: [
        .target(
            name: "SwiftPhotoGallery",
            dependencies: [
                "Kingfisher"
            ],
            path: "Pod/Classes"
        )
    ]
)
