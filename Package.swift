// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GitLibrary",
    platforms: [ .macOS(.v15) ],
    products: [ .library(name: "GitLibrary", targets: ["GitLibrary"]) ],
    targets: [ .target( name: "GitLibrary") ]
)
