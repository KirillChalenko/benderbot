import Vapor


/// Bot errors enum.
enum BotError: Swift.Error {
    /// Missing secret key in Config/app.json.
    case missingSecretKey
}


let config = try Config()
let drop = try Droplet(config)

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
    
    drop.console.info("New message has come")
    
    /// Chat ID from request JSON.
    let chatID: Int = request.data["message", "chat", "id"]?.int ?? 0
    /// Message text from request JSON.
    let message: String = request.data["message", "text"]?.string ?? ""
    /// User first name from request JSON.
    let userFirstName: String = request.data["message", "from", "first_name"]?.string ?? ""
    
    drop.console.info("chat id = " + String(chatID))
    drop.console.info("message = " + message)
    drop.console.info("user first name = " + userFirstName)
    
    /// Check if the message is empty
    if message.isEmpty {
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

drop.console.info("Starting server")

try drop.run()
