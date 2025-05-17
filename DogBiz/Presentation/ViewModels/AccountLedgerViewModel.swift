//
//  ViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
@MainActor
class AccountLedgerViewModel: ObservableObject {
    @Published var ledgers: [AccountLedger] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: IFectchAccountLedgerUseCase

    init(useCase: IFectchAccountLedgerUseCase) {
        self.useCase = useCase
    }
    
    func sortLedgersByDateDescending() async {
        ledgers.sort { $0.transactionDate < $1.transactionDate }
    }

    func loadLedgers(initialDate:String, endDate:String, accountingAccountId:Int, projectionFlag:Bool) async {
        isLoading = true
        errorMessage = nil
        let request = AccountLedgerRequest(
            InitialDate: initialDate,
            EndDate: endDate,
            AccountingAccountId: accountingAccountId,
            ProjectionFlag: projectionFlag
        )

        do {
            let data = try await useCase.execute(request: request)
            self.ledgers = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
