import Vapor


let config = try Config()

let drop = try Droplet(config)

try drop.run()
