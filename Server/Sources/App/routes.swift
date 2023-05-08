import Vapor
import Shared
import Foundation

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("greet", use: greet)
    app.post("echo", use: echo)
    app.get("donuts", use: donuts)
    app.post("donuts", use: addDonuts)
}

func greet(request: Request) async throws -> String {
    return "Hello from Swift Server"
}

func echo(request: Request) async throws -> String {
    if let body = request.body.string {
        return body
    }
    return ""
}

func donuts(request: Request) async throws -> DonutsResponse {
    return DonutsResponse(donuts: [
        SharedDataModel.Donut(id: UUID(), name: "First Donut"),
        SharedDataModel.Donut(id: UUID(), name: "Second Donut"),
        SharedDataModel.Donut(id: UUID(), name: "Tasty Donut")
    ])
}

func addDonuts(request: Request) async throws -> SuccessResponse {
    try SharedDataModel.Donut.validate(content: request)
    var headers = HTTPHeaders()
    headers.add(name: .contentType, value: "application/json")
    return SuccessResponse(response: "Successfull response")
}

struct SuccessResponse: Encodable, AsyncResponseEncodable {
    
    let response: String
    
    func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        let data = try jsonEncoder.encode(self)
        return .init(status: .ok, headers: headers, body: .init(data: data))
    }
}

struct DonutsResponse: AsyncResponseEncodable {
    let donuts: [SharedDataModel.Donut]
    
    func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        let data = try jsonEncoder.encode(donuts)
        return .init(status: .ok, headers: headers, body: .init(data: data))
    }
}

// MARK: - Validations
extension SharedDataModel.Donut: Validatable {
    public static func validations(_ validations: inout Vapor.Validations) {
        validations.add("id", as: UUID.self)
        validations.add("name", as: String.self, is: !.empty, customFailureDescription: "Provided name is empty!")
        validations.add("name", as: String.self, is: .count(4...), customFailureDescription: "Provided name should be more than 3 characters long!")
    }
}
