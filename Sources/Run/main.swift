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
    
    /// Handle message
    let response = handleMessage(message: message, userName: userFirstName)
    
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
