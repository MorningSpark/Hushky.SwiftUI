//
//  AccountLedger.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
struct AccountLedger: Identifiable, Codable{
    let id: Int
    let transactionDate: Date
    let description: String
    let saldo: Double
}
