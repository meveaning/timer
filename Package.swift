// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "TimerApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "TimerApp", targets: ["TimerApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "TimerApp",
            dependencies: [],
            path: "Sources"
        )
    ]
)