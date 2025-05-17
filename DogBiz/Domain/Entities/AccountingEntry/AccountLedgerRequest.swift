//
//  AccountLedgerRequest.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
struct AccountLedgerRequest: Encodable {
    let InitialDate: String
    let EndDate: String
    let AccountingAccountId: Int
    let ProjectionFlag: Bool
    
    init(InitialDate: String, EndDate: String, AccountingAccountId: Int, ProjectionFlag: Bool) {
        self.InitialDate = InitialDate
        self.EndDate = EndDate
        self.AccountingAccountId = AccountingAccountId
        self.ProjectionFlag = ProjectionFlag
    }
}
