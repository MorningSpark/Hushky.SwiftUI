//
//  IFetchAccountLedgerUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
protocol IFectchAccountLedgerUseCase {
    func execute(request: AccountLedgerRequest)async throws -> [AccountLedger]
}
