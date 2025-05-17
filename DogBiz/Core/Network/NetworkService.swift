//
//  DefaultNetworkService.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation

class NetworkService: INetworkService {
    func get<T: Decodable>(url: URL, headers: [String : String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return try await execute(request)
    }

    func post<T: Decodable, U: Encodable>(url: URL, body: U, headers: [String : String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request)
    }

    func put<T: Decodable, U: Encodable>(url: URL, body: U, headers: [String : String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request)
    }

    func delete<T: Decodable>(url: URL, headers: [String : String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return try await execute(request)
    }

    private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: data)
    }
}
