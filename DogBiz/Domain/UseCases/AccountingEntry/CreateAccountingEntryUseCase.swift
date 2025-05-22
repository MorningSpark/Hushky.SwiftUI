//
//  CreateAccountingEntry.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct CreateAccountingEntryUseCase: ICreateAccountingEntryUseCase {
    private let repository: IAccountingEntryRepository
    
    init(repository: IAccountingEntryRepository) {
        self.repository = repository
    }
    
    func execute(request: AccountingEntryRequest) async throws -> AccountingEntry {
        try await repository.CreateAccountEntry(request: request)
    }
}
