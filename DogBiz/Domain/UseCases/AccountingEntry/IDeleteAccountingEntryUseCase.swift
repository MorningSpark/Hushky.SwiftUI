//
//  DeleteAccountingEntryUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 30/5/25.
//

import Foundation
protocol IDeleteAccountingEntryUseCase {
    func execute(accountingEntryId: String )async throws -> Int
}
