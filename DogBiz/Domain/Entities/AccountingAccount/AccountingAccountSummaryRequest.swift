//
//  AccountingAccountSumaryRequest.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
struct AccountingAccountSumaryRequest: Encodable {
    let InitialDate: String
    let EndDate: String
    let ProjectionFlag: Bool
    let AbsoluteBalance: Bool
}
