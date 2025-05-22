//
//  AccountingAccountAllViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 22/5/25.
//

import Foundation
@MainActor
class AccountingAccountAllViewModel: ObservableObject {
    @Published var accountingAccounts: [AccountingAccount] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: IFectchAllAccountingAccountUseCase

    init(useCase: IFectchAllAccountingAccountUseCase) {
        self.useCase = useCase
    }
    
    func sortLedgersByDateDescending() async {
        accountingAccounts.sort { $0.referenceCode < $1.referenceCode }
    }

    func loadAccountingAccounts(isTranasction: Bool) async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await useCase.execute()
            self.accountingAccounts =  data.filter { $0.transaction==isTranasction }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func loadAccountingAccounts() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await useCase.execute()
            self.accountingAccounts = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
