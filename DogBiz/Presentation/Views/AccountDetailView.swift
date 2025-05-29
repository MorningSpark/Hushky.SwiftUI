//
//  AccountDetailView.swift
//  Cuentifico
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import SwiftUI

struct AccountDetailView: View {
    let initialDateScope: Date
    let endDateScope: Date
    let proyeccionScope: Bool
    
    let account: AccountingAccountSumary
    @StateObject private var viewModel = AccountLedgerViewModel(
        useCase: FetchAccountLedgerUseCase(
            repository: AccountingEntryRepository(networkService: NetworkService())
        )
    )
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    
    var body: some View {
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
                    
                }
                .overlay {
                    if viewModel.isLoading && viewModel.ledgers.isEmpty {
                        ProgressView()
                    }
                }
                .refreshable {
                    await viewModel.loadLedgers(initialDate:formatDate(initialDateScope),endDate:formatDate(endDateScope), accountingAccountId: account.id, projectionFlag: proyeccionScope)
                    await viewModel.sortLedgersByDateDescending()
                }
                .alert(isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.errorMessage ?? ""),
                          dismissButton: .default(Text("OK")))
                }
                
            }.task {
                await viewModel.loadLedgers(initialDate:formatDate(initialDateScope),endDate:formatDate(endDateScope), accountingAccountId: account.id, projectionFlag: proyeccionScope)
                await viewModel.sortLedgersByDateDescending()
            }
        }
}

