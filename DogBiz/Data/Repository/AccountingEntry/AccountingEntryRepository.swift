//
//  AccountingEntryRepository.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
class AccountingEntryRepository: IAccountingEntryRepository {
    private let networkService: INetworkService
    private let baseURL = "https://www.eva-core.net:5002"

    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func fetchAccountLedger(request: AccountLedgerRequest) async throws -> [AccountLedger] {
        guard let url=URL(string:baseURL + "/api/AccountingEntry/GeneralLedger") else{
            throw URLError(.badURL)
        }
        return try await networkService.post(url: url, body: request, headers: nil)
    }
    
    func CreateAccountEntry(request: AccountingEntryRequest) async throws -> AccountingEntry {
        guard let url = URL(string: baseURL + "/api/AccountingEntry" ) else {
            throw URLError(.badURL)
        }
        return try await networkService.post(url: url, body: request, headers: nil)
    }
    
    func FetchAccountingEntryRange(initialDate: String? = nil, finalDate: String? = nil) async throws -> [AccountingEntry] {
        var urlString = baseURL + "/api/AccountingEntry"

        // Construcción de parámetros de consulta
        var queryItems: [URLQueryItem] = []
        
        if let initialDate = initialDate {
            queryItems.append(URLQueryItem(name: "initialDate", value: initialDate))
        }
        if let finalDate = finalDate {
            queryItems.append(URLQueryItem(name: "finalDate", value: finalDate))
        }

        // Si hay parámetros, agregarlos a la URL
        if !queryItems.isEmpty {
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryItems
            guard let finalURL = urlComponents?.url else {
                throw URLError(.badURL)
            }
            return try await networkService.get(url: finalURL, headers: nil)
        }

        // Si no hay parámetros, usar la URL sin modificaciones
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await networkService.get(url: url, headers: nil)
    }
}
