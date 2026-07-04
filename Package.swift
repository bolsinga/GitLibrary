// swift-tools-version: 6.3

import PackageDescription

let package = Package(
  name: "GitLibrary",
  platforms: [.macOS(.v26), .iOS(.v26)],
  products: [.library(name: "GitLibrary", targets: ["GitLibrary"])],
  targets: [
    .target(name: "GitLibrary"),
    .testTarget(name: "GitLibraryTests", dependencies: ["GitLibrary"]),
  ]
)
