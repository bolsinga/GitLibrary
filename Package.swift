// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "GitLibrary",
  platforms: [.macOS(.v15), .iOS(.v18)],
  products: [.library(name: "GitLibrary", targets: ["GitLibrary"])],
  targets: [
    .target(name: "GitLibrary"),
    .testTarget(name: "GitLibraryTests", dependencies: ["GitLibrary"]),
  ]
)
