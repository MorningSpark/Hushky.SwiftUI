//
//  AccountingAccountSummary.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
struct AccountingAccountSumary: Identifiable, Decodable {
    let id: Int
    let name: String
    let referenceCode: String
    let balance: Double
    
    var level: Int {
        return referenceCode.components(separatedBy: ".").count
    }
}
