//
//  IFetchAccountingEntryRangeUseCase.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 27/5/25.
//

import Foundation
protocol IFetchAccountingEntryRangeUseCase {
    func execute(initialDate: String?, finalDate :String?)async throws -> [AccountingEntry]
}
