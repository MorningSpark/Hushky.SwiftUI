//
//  FetchAccountSummaryUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
class FetchAccountSummaryUseCase: IFetchAccountSummaryUseCase {
    private let repository: IAccountingAccountRepository

    init(repository: IAccountingAccountRepository) {
        self.repository = repository
    }

    func execute(request: AccountingAccountSumaryRequest) async throws -> [AccountingAccountSumary] {
        try await repository.fetchSummary(request: request)
    }
}
