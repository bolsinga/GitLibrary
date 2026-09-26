// swift-tools-version: 6.4

import PackageDescription

let package = Package(
  name: "GitLibrary",
  platforms: [.macOS(.v27), .iOS(.v27)],
  products: [.library(name: "GitLibrary", targets: ["GitLibrary"])],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "GitLibrary",
      dependencies: [
        .product(
          name: "Subprocess", package: "swift-subprocess", condition: .when(platforms: [.macOS]))
      ]),
    .testTarget(name: "GitLibraryTests", dependencies: ["GitLibrary"]),
  ]
)
