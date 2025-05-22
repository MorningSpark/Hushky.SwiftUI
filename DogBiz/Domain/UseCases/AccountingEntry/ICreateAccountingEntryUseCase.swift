//
//  ICreateAccountingEntryUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
protocol ICreateAccountingEntryUseCase {
    func execute(request: AccountingEntryRequest)async throws -> AccountingEntry
}
