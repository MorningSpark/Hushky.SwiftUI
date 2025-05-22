//
//  AccountingEntry.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
struct AccountingEntry: Decodable {
    let id: Int
    let transactionId: Int?
    let description: String
    let breed: Int
    let projection: Bool
    let referenceValue: Double
    let creationDate: String
    let alterDate: String?
}
