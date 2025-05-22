//
//  IFetchAllAccountingAccounts.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
protocol IFectchAllAccountingAccountUseCase {
    func execute()async throws -> [AccountingAccount]
}
