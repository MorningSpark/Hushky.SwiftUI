import SwiftUI

// MARK: - Modelo de entrada contable
struct TemporalAccountingEntry: Identifiable {
    let id = UUID()
    let account: AccountingAccount
    let debitAmount: Double
    let creditAmount: Double
}

// MARK: - Vista Principal
struct AccountingEntryCreateView: View {
    @State private var selectedAccount: AccountingAccount?
    @State private var accountValue = ""
    @State private var accountType = "Débito"
    @State private var accountReference = ""
    @State private var accountingEntries: [TemporalAccountingEntry] = []
    @State private var showAccountSearch = false
    @State private var showSuccessAlert = false

    
    @StateObject private var viewModel = AccountingAccountAllViewModel(
        useCase: FetchAllAccountingAccountUseCase(
            repository: AccountingAccountRepository(networkService: NetworkService())
        )
    )
    
    @StateObject private var createEntryViewModel = CreateAccountingEntryViewModel(
        useCase: CreateAccountingEntryUseCase(
            repository: AccountingEntryRepository(networkService: NetworkService())
        )
    )

    var totalCredit: Double {
        accountingEntries.reduce(0) { $0 + $1.creditAmount }
    }

    var totalDebit: Double {
        accountingEntries.reduce(0) { $0 + $1.debitAmount }
    }

    var isConfirmEnabled: Bool {
        totalCredit == totalDebit && !accountingEntries.isEmpty
    }

    var body: some View {

            Form {
                
                // MARK: - Agregar Cuenta
                Section(header: Text("Agregar Cuenta")) {
                    Button(action: {
                        showAccountSearch = true
                    }) {
                        HStack {
                            Text(selectedAccount?.name ?? "Seleccionar cuenta contable")
                                .foregroundColor(selectedAccount == nil ? .gray : .primary)
                            Spacer()
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .sheet(isPresented: $showAccountSearch) {
                        AccountSearchView(accounts: viewModel.accountingAccounts) { account in
                            selectedAccount = account
                        }
                    }

                    TextField("Valor", text: $accountValue)
                        .keyboardType(.decimalPad)

                    HStack {
                        Picker("Tipo", selection: $accountType) {
                            Text("Débito").tag("Débito")
                            Text("Crédito").tag("Crédito")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button {
                            let formattedValue = accountValue.replacingOccurrences(of: ",", with: ".")
                            if let amount = Double(formattedValue), let account = selectedAccount {
                                let entry = TemporalAccountingEntry(
                                    account: account,
                                    debitAmount: accountType == "Débito" ? amount : 0,
                                    creditAmount: accountType == "Crédito" ? amount : 0
                                )
                                accountingEntries.append(entry)
                                selectedAccount = nil
                                accountValue = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .task {
                    await viewModel.loadAccountingAccounts(isTranasction: true)
                }

                

                // MARK: - Débitos
                Section(header: Text("Débitos - Total: \(totalDebit, specifier: "%.2f")")) {
                    ForEach(accountingEntries.filter { $0.debitAmount > 0 }) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(entry.account.name) - \(entry.debitAmount, specifier: "%.2f")")
                            }
                            Spacer()
                            Button {
                                accountingEntries.removeAll { $0.id == entry.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                // MARK: - Créditos
                Section(header: Text("Créditos - Total: \(totalCredit, specifier: "%.2f")")) {
                    ForEach(accountingEntries.filter { $0.creditAmount > 0 }) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(entry.account.name) - \(entry.creditAmount, specifier: "%.2f")")
                            }
                            Spacer()
                            Button {
                                accountingEntries.removeAll { $0.id == entry.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 5)
                    }
                }

                // MARK: - Finalizar Transacción
                Section(header: Text("Referencia de Transacción")) {
                    TextEditor(text: $accountReference)
                        .frame(height: 100)
                        

                    if createEntryViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView("Guardando...")
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    }

                    
                }
                
                Section{
                    Button(action:{
                        Task {
                            let details = accountingEntries.map {
                                AccountingEntryDetailRequest(
                                    accountingAccountId: $0.account.id,
                                    debitAmount: $0.debitAmount,
                                    creditAmount: $0.creditAmount
                                )
                            }

                            let request = AccountingEntryRequest(
                                description: accountReference.isEmpty ? "prueba gogo" : accountReference,
                                breed: 0,
                                Date: nil,
                                Projection: false,
                                TransactionId: nil,
                                accountingEntryDetails: details
                            )

                            await createEntryViewModel.createAccountingEntry(acocuntingEntry: request)
                            if createEntryViewModel.result != nil {
                                        showSuccessAlert = true
                                        accountingEntries.removeAll()
                                        accountReference = ""
                                    }
                        }
                    }) {
                        Text("Confirmar Transaccion")
                            .frame(maxWidth: .infinity, alignment: .center).buttonStyle(.borderedProminent)
                            .padding()
                        
                    }
                    .disabled(!isConfirmEnabled || createEntryViewModel.isLoading)
                    .buttonStyle(.borderedProminent)
                    .listRowInsets(EdgeInsets())
                }
                
                
                
            }
            .navigationTitle("Registro Contable")
            .alert("Se ha ingresado el registro satisfactoriamente", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            }
        }
}

// MARK: - Vista de búsqueda de cuentas
struct AccountSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    let accounts: [AccountingAccount]
    let onSelect: (AccountingAccount) -> Void

    var filteredAccounts: [AccountingAccount] {
        if searchText.isEmpty {
            return accounts
        } else {
            return accounts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.reference.localizedCaseInsensitiveContains(searchText) ||
                $0.referenceCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredAccounts) { account in
                Button {
                    onSelect(account)
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(account.name).fontWeight(.medium)
                        Text("\(account.referenceCode) - \(account.reference)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Selecciona Cuenta")
            .searchable(text: $searchText, prompt: "Buscar por nombre o código")
        }
    }
}

// MARK: - Vista previa
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountingEntryCreateView()
    }
}
