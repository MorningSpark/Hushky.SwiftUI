//
//  FetchAccountLedgerUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
struct FetchAccountLedgerUseCase: IFectchAccountLedgerUseCase {
    private let repository: IAccountingEntryRepository
    
    init(repository: IAccountingEntryRepository) {
        self.repository = repository
    }
    
    func execute(request: AccountLedgerRequest) async throws -> [AccountLedger] {
        try await repository.fetchAccountLedger(request: request)
    }
}
