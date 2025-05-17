//
//  AccountDetailView.swift
//  Cuentifico
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import SwiftUI

struct AccountDetailView: View {
    let account: AccountingAccountSumary
    @StateObject private var viewModel = AccountLedgerViewModel(
        useCase: FetchAccountLedgerUseCase(
            repository: AccountingEntryRepository(networkService: NetworkService())
        )
    )
    
    var body: some View {
        NavigationView {
            VStack() {
                Text(account.name)
                    .font(.largeTitle)
                    .bold()

                Text("Balance: \(String(format: "$%.2f", account.balance))")
                    .font(.title2)

                Text("Referencia: \(account.referenceCode)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()
                
                List(viewModel.ledgers, id: \.id){ resume in
                    HStack {
                        VStack(alignment: .leading){
                            TransactionDateView(transactionDate:resume.transactionDate).font(.headline)
                            Text(String(resume.description)).font(.subheadline).foregroundColor(.gray)
                        }
                        Spacer()
                        Text(String(format: "%.2f$", abs(resume.saldo))).font(.subheadline).foregroundColor(resume.saldo>=0 ? .green : .red)
                    }
                    
                }.alert(isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.errorMessage ?? ""),
                          dismissButton: .default(Text("OK")))
                }
                
            }.task {
                await viewModel.loadLedgers(initialDate: "2025-05-01", endDate: "2025-05-30", accountingAccountId: account.id, projectionFlag: false)
                await viewModel.sortLedgersByDateDescending()
            }
        }
    }
}

