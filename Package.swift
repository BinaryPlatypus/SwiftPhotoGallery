// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPhotoGallery",
    platforms: [
        .iOS(.v14), .tvOS(.v14)
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
