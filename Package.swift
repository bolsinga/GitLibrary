// swift-tools-version: 6.3

import PackageDescription

let package = Package(
  name: "GitLibrary",
  platforms: [.macOS(.v26), .iOS(.v26)],
  products: [.library(name: "GitLibrary", targets: ["GitLibrary"])],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "GitLibrary", dependencies: [.product(name: "Subprocess", package: "swift-subprocess")]),
    .testTarget(name: "GitLibraryTests", dependencies: ["GitLibrary"]),
  ]
)
