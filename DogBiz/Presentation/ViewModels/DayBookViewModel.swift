//
//  ViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
@MainActor
class DayBookViewModel: ObservableObject {
    @Published var accountingEntries: [AccountingEntry] = []
    @Published var accountingEntryResultCode: Int
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: IFetchAccountingEntryRangeUseCase
    private let deleteAccountingEntryuseCase: IDeleteAccountingEntryUseCase

    init(useCase: IFetchAccountingEntryRangeUseCase, deleteAccountingEntryuseCase: IDeleteAccountingEntryUseCase) {
        self.useCase = useCase
        self.deleteAccountingEntryuseCase = deleteAccountingEntryuseCase
        self.accountingEntryResultCode = 0
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
    
    func deleteAccountingEntry(accountingEntryId:String) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await deleteAccountingEntryuseCase.execute(accountingEntryId: accountingEntryId)
            self.accountingEntryResultCode = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    
}
