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
}
