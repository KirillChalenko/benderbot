//
//  MessageUtils.swift
//  BenderBotPackageDescription
//
//  Created by Kirill Chalenko on 12/21/17.
//

import Foundation

func random(max: Int) -> Int {
    #if os(Linux)
        return Int(random() % (max + 1))
    #else
        return Int(arc4random_uniform(UInt32(max)))
    #endif
}

func randomGreeting() -> String {
    let greetings = ["What's up man!", "Hi human slave!", "Ola! Tudo Bom?", "Hey sexy mama, wanna kill all humans?"]
    return greetings[random(max: greetings.count)]
}

func randomQuote() -> String {
    let quotes = [
        "I guess if you want children beaten, you have to do it yourself.",
        "I’ll build by own theme park. With black jack, and hookers. In fact, forget the park!",
        "The game’s over. I have all the money. Compare your lives to mine and then kill yourselves!",
        "That’s closest thing to ‘Bender is great’ that anyone other me has ever said.",
        "I’m Bender, baby! Oh god, please insert liquor!",
        "Hey sexy mama, wanna kill all humans?",
        "You know what cheers me up? Other people’s misfortune.",
        "Anything less than immortality is a complete waste of time.",
        "Blackmail is such an ugly word. I prefer extortion. The ‘x’ makes it sound cool.",
        "Have you tried turning off the TV, sitting down with your children, and hitting them?",
        "Oh, your God!",
        "I’m so embarrassed. I wish everyone else was dead!",
        "I got ants my butt, and I needs to strut!",
        "Afterlife? If I thought I had to live another life, I’d kill myself right now!"
    ]
    return quotes[random(max: quotes.count)]
}

func handleMessage(message: String, userName: String) -> String {
    var response: String = ""
    
    if message.isEmpty {
        response = "Your message is empty, human..."
    } else {
        if message.hasPrefix("/") {
            switch message {
            case "/start":
                response = "Welcome to the Future, human slave!"
            case "/help":
                response = "Hahaha. Relax " + userName + "\n" +
                    "/start - Welcome from the smartest robot\n" +
                    "/help - Help youself, human\n" +
                    "/quote - Listen to a witty quote from me\n"
            case "/quote":
                response = randomQuote()
            default:
                response = "Unrecognized command.\nTo list all available commands type /help"
            }
        } else {
            switch message.lowercased() {
            case "hi", "hey", "ola", "whats up":
                response = randomGreeting()
            case "rapha":
                response = "http://joxi.net/82QEk7Mu1N3ak2.jpg"
            case "rapha age":
                response = "Some people told me, that he is older than all brazilians..hehehe\n" +
                "But I think he is even older!"
            default:
                response = "I hate humans"
            }
        }
    }
    
    return response
}
