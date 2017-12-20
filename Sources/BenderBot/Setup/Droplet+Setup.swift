@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
    }

    /// Read the secret key from Config/app.json.
    public func getSecretKey() -> String? {

        guard let secret = drop.config["app", "secret"]?.string else {
            /// Show errors in console.
            drop.console.error("Missing secret key!")
            drop.console.warning("Add one in Config/app.json")

            /// Throw missing secret key error.
            throw BotError.missingSecretKey
        }
    }
}
