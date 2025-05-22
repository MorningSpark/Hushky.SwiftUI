//
//  FectchAllAccountingAccountUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct FetchAllAccountingAccountUseCase: IFectchAllAccountingAccountUseCase {
    private let repository: IAccountingAccountRepository
    
    init(repository: IAccountingAccountRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [AccountingAccount] {
        try await repository.fetchAllAccountingAccounts()
    }
}
