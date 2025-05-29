//
//  AccountingEntryRepository.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation

protocol IAccountingEntryRepository {
    func fetchAccountLedger(request: AccountLedgerRequest) async throws -> [AccountLedger]
    func CreateAccountEntry(request: AccountingEntryRequest) async throws -> AccountingEntry
    func FetchAccountingEntryRange(initialDate: String?, finalDate :String?) async throws -> [AccountingEntry]
}
