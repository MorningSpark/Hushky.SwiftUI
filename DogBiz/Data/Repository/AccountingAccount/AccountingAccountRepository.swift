//
//  Repository.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation

class AccountingAccountRepository: IAccountingAccountRepository {
    
    
    private let networkService: INetworkService
    private let baseURL = "https://www.eva-core.net:5002"

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func fetchSummary(request: AccountingAccountSumaryRequest) async throws -> [AccountingAccountSumary] {
        guard let url = URL(string: baseURL + "/api/AccountingAccount/resume") else {
            throw URLError(.badURL)
        }
        return try await networkService.post(url: url, body: request, headers: nil)
    }
    
    func fetchAllAccountingAccounts() async throws -> [AccountingAccount] {
        guard let url = URL(string: baseURL + "/api/AccountingAccount") else {
            throw URLError(.badURL)
        }
        return try await networkService.get(url: url, headers: nil)
    }
}
