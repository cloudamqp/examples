// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "mqtt-example",
    platforms: [.macOS(.v13), .iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/swift-server-community/mqtt-nio.git", from: "2.13.0"),
    ],
    targets: [
        .executableTarget(name: "publisher", dependencies: [.product(name: "MQTTNIO", package: "mqtt-nio")]),
        .executableTarget(name: "worker", dependencies: [.product(name: "MQTTNIO", package: "mqtt-nio")]),
        .testTarget(name: "RoundtripTests", dependencies: ["publisher", "worker"]),
    ]
)
