//
//  AccountingAccount.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation

struct AccountingAccount: Identifiable, Codable {
    let id: Int
    let parentId: Int
    let referenceCode: String
    let reference: String
    let name: String
    let resource: String?
    let transaction:Bool?
    let referenceValue: Double?
    let creationDate: String
    let alterDate: String?
}
