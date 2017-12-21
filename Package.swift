import PackageDescription

let package = Package(
    name: "BenderBot",
    targets: [
        Target(name: "Run")
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources"
    ]
)

