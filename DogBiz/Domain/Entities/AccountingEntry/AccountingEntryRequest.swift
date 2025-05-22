//
//  AccountingEntryRequest.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct AccountingEntryRequest: Codable {
    let description: String
    let breed: Int
    let Date: String?
    let Projection: Bool
    let TransactionId: Int?
    let accountingEntryDetails: [AccountingEntryDetailRequest]
}
