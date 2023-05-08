//
//  MyServerClient.swift
//  TestApp
//
//  Created by Vlastimir Radojevic on 20.4.23..
//

import Foundation
import Shared

struct MyServerClient {
    let baseUrl = URL(string: "http://Vlastimirs-MacBook-Pro.local:8080")!
    
    func greet() async throws -> String {
        let url = baseUrl.appendingPathComponent("greet")
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let responseBody = String(data: data, encoding: .utf8) else {
            throw Errors.invalidResponseEncoding
        }
        return responseBody
    }
    
    enum Errors: Error {
        case invalidResponseEncoding
    }
    
    
    func listDonuts() async throws -> [SharedDataModel.Donut] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let url = baseUrl.appendingPathComponent("donuts")
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let response = try decoder.decode([SharedDataModel.Donut].self, from: data)
        return response
    }
    
    enum Response {
        struct DonutsList: Codable {
            var donuts: [SharedDataModel.Donut]
        }
    }
}
