//
//  NetworkService.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation

protocol INetworkService {
    func get<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U, headers: [String: String]?) async throws -> T
    func put<T: Decodable, U: Encodable>(url: URL, body: U, headers: [String: String]?) async throws -> T
    func delete<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T
}

