// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphXcodeProj",
    products: [
      .executable(name: "xcodeproj-to-graph", targets: ["GraphXcodeProj"]),
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
      .package(url: "https://github.com/seshness/XcodeProj.git", .upToNextMajor(from: "8.20.0-beta.1")),
    ],
    targets: [
      .executableTarget(
        name: "GraphXcodeProj",
        dependencies: [
          "XcodeProj",
          .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]
      ),
    ]
)
