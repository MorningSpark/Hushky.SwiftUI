//
//  IAccountRepository.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation

protocol IAccountingAccountRepository {
    func fetchSummary(request: AccountingAccountSumaryRequest) async throws -> [AccountingAccountSumary]
    func fetchAllAccountingAccounts() async throws -> [AccountingAccount]
}

