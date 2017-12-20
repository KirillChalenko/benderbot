import BenderBot


let config = try Config()
try config.setup()

let drop = try Droplet(config)
try drop.setup()

/// Read the secret key from Config/secrets/app.json.
guard let secret = drop.config["app", "secret"]?.string else {
    /// Show errors in console.
    drop.console.error("Missing secret key!")
    drop.console.warning("Add one in Config/app.json")

    /// Throw missing secret key error.
    throw BotError.missingSecretKey
}

/// Setting up the POST request with the secret key.
/// With a secret path to be sure that nobody else knows that URL.
/// https://core.telegram.org/bots/api#setwebhook
drop.post(secret) { request in
    /// Let's prepare the response message text.
    var response: String = ""

    /// Chat ID from request JSON.
    let chatID: Int = request.data["message", "chat", "id"]?.int ?? 0
    /// Message text from request JSON.
    let message: String = request.data["message", "text"]?.string ?? ""
    /// User first name from request JSON.
    var userFirstName: String = request.data["message", "from", "first_name"]?.string ?? ""

    /// Check if the message is empty
    if message.characters.isEmpty {
        /// Set the response message text.
        response = "I'm sorry but your message is empty 😢"
    /// The message is not empty
    } else {
        /// Check if the message is a Telegram command.
        if message.hasPrefix("/") {
            /// Check what type of command is.
            switch message {
            /// Start command "/start".
            case "/start":
                /// Set the response message text.
                response = "Welcome to BenderBot " + userFirstName + "!\n" +
                           "To list all available commands type /help"
            /// Help command "/help".
            case "/help":
                /// Set the response message text.
                response = "Welcome to BenderBot " +
                           "/start - Welcome message\n" +
                           "/help - Help message\n"
            /// Command not valid.
            default:
                /// Set the response message text and suggest to type "/help".
                response = "Unrecognized command.\nTo list all available commands type /help"
            }
        } else {
            /// Set the response message text.
            response = message + " motherfucker"
        }
    }

    /// Create the JSON response.
    /// https://core.telegram.org/bots/api#sendmessage
    return try JSON(node:
        [
            "method": "sendMessage",
            "chat_id": chatID,
            "text": response
        ]
    )
}

try drop.run()
