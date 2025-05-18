//
//  ContentView.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 15/5/25.
//

import SwiftUI


struct ContentView: View {
    let initialDateScope: Date
    let endDateScope: Date
    let proyeccionScope: Bool
    @StateObject private var viewModel = AccountSummaryViewModel(
        useCase: FetchAccountSummaryUseCase(
            repository: AccountingAccountRepository(networkService: NetworkService())
        )
    )
    @State private var expandedAccounts: Set<Int> = []
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    List{
                        ForEach(rootAccounts()) { account in
                            accountView(for: account)
                        }
                    }.listRowSeparator(.visible)
                    .navigationTitle("Resumen de Cuentas")
                    .overlay {
                        if viewModel.isLoading && viewModel.summaries.isEmpty {
                            ProgressView()
                        }
                    }
                    .refreshable {
                        await viewModel.loadSummaries(initialDate:formatDate(initialDateScope),endDate:formatDate(endDateScope), projection: proyeccionScope)
                    }
                    .alert(isPresented: Binding<Bool>(
                        get: { viewModel.errorMessage != nil },
                        set: { _ in viewModel.errorMessage = nil }
                    )) {
                        Alert(title: Text("Error"),
                              message: Text(viewModel.errorMessage ?? ""),
                              dismissButton: .default(Text("OK")))
                    }
                    .task {
                        await viewModel.loadSummaries(initialDate:formatDate(initialDateScope),endDate:formatDate(endDateScope), projection: proyeccionScope)
                    }
                }
            }
            
        }
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    
    // Nivel 1 (cuentas raíz)
    func rootAccounts() -> [AccountingAccountSumary] {
        viewModel.summaries.filter { $0.level == 1 }
    }
    
    // Subcuentas inmediatas
    func childAccounts(of parent: AccountingAccountSumary) -> [AccountingAccountSumary] {
        let nextLevel = parent.level + 1
        let prefix = parent.referenceCode + "."
        return viewModel.summaries.filter {
            $0.referenceCode.hasPrefix(prefix) && $0.level == nextLevel
        }
    }
    
    func getColor(for level: Int) -> Color {
        switch level {
        case 1: return .blue
        case 2: return .green
        case 3: return .orange
        case 4: return .purple
        default: return .gray
        }
    }
    
    func rowView(for account: AccountingAccountSumary) -> some View {
        HStack {
            Rectangle()
                .frame(width: 10, height: 10)
                .cornerRadius(2)
                .foregroundColor(getColor(for: account.level))

            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                Text("Referencia: \(account.referenceCode)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(String(format: "$%.2f", account.balance))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    // Vista recursiva
    func accountView(for account: AccountingAccountSumary
    ) -> AnyView {
        let children = childAccounts(of: account)

        if children.isEmpty {
            // Es hoja → ir a detalle
            return AnyView(
                NavigationLink(destination: AccountDetailView(initialDateScope: self.initialDateScope, endDateScope: self.endDateScope, proyeccionScope: self.proyeccionScope, account: account)) {
                    rowView(for: account)
                }
            )
        } else {
            // Tiene hijos → DisclosureGroup
            return AnyView(
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedAccounts.contains(account.id) },
                        set: { isExpanded in
                            if isExpanded {
                                expandedAccounts.insert(account.id)
                            } else {
                                expandedAccounts.remove(account.id)
                            }
                        }
                    )
                ) {
                    ForEach(children) { child in
                        accountView(for: child)
                    }
                } label: {
                    rowView(for: account)
                }
            )
        }
    }
    
}

