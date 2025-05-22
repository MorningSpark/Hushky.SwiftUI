//
//  ViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
@MainActor
class CreateAccountingEntryViewModel: ObservableObject {
    @Published var result: AccountingEntry? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: ICreateAccountingEntryUseCase

    init(useCase: ICreateAccountingEntryUseCase) {
        self.useCase = useCase
    }

    func createAccountingEntry(acocuntingEntry:AccountingEntryRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await useCase.execute(request: acocuntingEntry)
            self.result = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
