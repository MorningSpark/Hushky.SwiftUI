//
//  CustomUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation

protocol IFetchAccountSummaryUseCase {
    func execute(request: AccountingAccountSumaryRequest) async throws -> [AccountingAccountSumary]
}
