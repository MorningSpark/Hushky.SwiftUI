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

    func loadSummaries(initialDate:String,endDate:String, projection:Bool, absoluteBalance:Bool) async {
        isLoading = true
        errorMessage = nil
        let request = AccountingAccountSumaryRequest(
            InitialDate: initialDate,
            EndDate: endDate,
            ProjectionFlag: projection,
            AbsoluteBalance: absoluteBalance
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
