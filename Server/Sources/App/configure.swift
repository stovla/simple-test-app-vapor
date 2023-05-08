import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    // setting the hostname to be exposed to local network
    app.http.server.configuration.hostname = "Vlastimirs-MacBook-Pro.local"
//    app.http.server.configuration.port = 1337
}
