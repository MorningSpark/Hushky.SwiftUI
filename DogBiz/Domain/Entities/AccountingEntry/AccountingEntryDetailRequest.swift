//
//  AccountingEntryDetailRequest.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct AccountingEntryDetailRequest: Codable {
    let accountingAccountId: Int
    let debitAmount: Double
    let creditAmount: Double
}
