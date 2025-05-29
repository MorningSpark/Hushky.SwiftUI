//
//  ViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
@MainActor
class FetchAccountingEntryRangeViewModel: ObservableObject {
    @Published var accountingEntries: [AccountingEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: IFetchAccountingEntryRangeUseCase

    init(useCase: IFetchAccountingEntryRangeUseCase) {
        self.useCase = useCase
    }
    
    func sortLedgersByDateDescending() async {
        accountingEntries.sort { $0.creationDate < $1.creationDate }
    }

    func loadAccountingEntries(initialDate:String?=nil, finalDate:String?=nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await useCase.execute(initialDate: initialDate, finalDate: finalDate)
            self.accountingEntries = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
