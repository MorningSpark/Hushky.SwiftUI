//
//  CreateAccountingEntry.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct FetchAccountingEntryRangeUseCase: IFetchAccountingEntryRangeUseCase {
    private let repository: IAccountingEntryRepository
    
    init(repository: IAccountingEntryRepository) {
        self.repository = repository
    }
    
    func execute(initialDate: String?=nil, finalDate: String?=nil) async throws -> [AccountingEntry] {
        try await repository.FetchAccountingEntryRange(initialDate: initialDate, finalDate: finalDate)
    }
}
