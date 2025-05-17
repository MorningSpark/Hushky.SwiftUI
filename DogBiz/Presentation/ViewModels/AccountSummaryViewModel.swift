//
//  ViewModel.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import Foundation
@MainActor
class AccountSummaryViewModel: ObservableObject {
    @Published var summaries: [AccountingAccountSumary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: IFetchAccountSummaryUseCase

    init(useCase: IFetchAccountSummaryUseCase) {
        self.useCase = useCase
    }

    func loadSummaries() async {
        isLoading = true
        errorMessage = nil
        let request = AccountingAccountSumaryRequest(
            InitialDate: "2025-05-01",
            EndDate: "2025-05-31",
            ProjectionFlag: false
        )

        do {
            let data = try await useCase.execute(request: request)
            self.summaries = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
