//
//  DeleteAccountingEntryUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 30/5/25.
//

import Foundation
struct DeleteAccountingEntryUseCase: IDeleteAccountingEntryUseCase {
    private let repository: IAccountingEntryRepository
    
    init(repository: IAccountingEntryRepository) {
        self.repository = repository
    }
    
    func execute(accountingEntryId: String ) async throws -> Int {
        try await repository.DeleteAccountingEntry(accountEntryId: accountingEntryId)
    }
}
