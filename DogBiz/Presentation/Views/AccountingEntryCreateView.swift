import SwiftUI

// MARK: - Modelo de entrada contable
struct TemporalAccountingEntry: Identifiable {
    let id = UUID()
    let account: AccountingAccount
    let debitAmount: Decimal
    let creditAmount: Decimal
}

// MARK: - Vista Principal
struct AccountingEntryCreateView: View {
    @Environment(\.presentationMode) private var presentationMode

    @State private var selectedAccount: AccountingAccount?
    @State private var accountValue = ""
    @State private var accountType = "Debe"
    @State private var accountReference = ""
    @State private var accountingEntries: [TemporalAccountingEntry] = []
    @State private var showAccountSearch = false
    @State private var showToast = false
    @State private var selectedValue = 1

    let opciones = [
        (nombre: "Entrada", valor: 1),
        (nombre: "Salida", valor: 2)
    ]

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

    var totalCredit: Decimal {
        accountingEntries.reduce(0) { $0 + $1.creditAmount }
    }
    var totalDebit: Decimal {
        accountingEntries.reduce(0) { $0 + $1.debitAmount }
    }

    var isConfirmEnabled: Bool {
        totalCredit == totalDebit &&
        !accountingEntries.isEmpty &&
        !accountReference.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            Form() {
                // MARK: - Búsqueda de cuenta contable
                Section(header: Text("Buscar cuenta")) {
                    Button(action: { showAccountSearch = true }) {
                        HStack {
                            Text(selectedAccount?.name ?? "Seleccionar cuenta contable")
                                .foregroundColor(selectedAccount == nil ? .gray : .primary)
                            Spacer()
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        }
                    }.sheet(isPresented: $showAccountSearch) {
                        AccountSearchView(accounts: viewModel.accountingAccounts) { account in
                            selectedAccount = account
                        }
                    }
                }

                // MARK: - Agregar Cuenta
                Section(header: Text("Agregar valor")) {
                    TextField("Valor", text: $accountValue)
                        .keyboardType(.decimalPad)
                    HStack {
                        Picker("Tipo", selection: $accountType) {
                            Text("Debe").tag("Debe")
                            Text("Haber").tag("Haber")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button {
                            let formattedValue = accountValue.replacingOccurrences(of: ",", with: ".")
                            if let amount = Decimal(string: formattedValue), let account = selectedAccount {
                                let entry = TemporalAccountingEntry(
                                    account: account,
                                    debitAmount: accountType == "Debe" ? amount : 0,
                                    creditAmount: accountType == "Haber" ? amount : 0
                                )
                                accountingEntries.append(entry)
                                selectedAccount = nil
                                accountValue = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        } label: {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                }.task {
                    await viewModel.loadAccountingAccounts(isTranasction: true)
                }

                // MARK: - Debe
                Section(header: Text("Debe")) {
                    ForEach(accountingEntries.filter { $0.debitAmount > 0 }) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(entry.account.name)
                                    Spacer()
                                    Text("\(NSDecimalNumber(decimal: entry.debitAmount).doubleValue, specifier: "%.2f")")
                                }
                            }
                            Spacer()
                            Button {
                                accountingEntries.removeAll { $0.id == entry.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }.buttonStyle(BorderlessButtonStyle())
                        }.padding(.vertical, 5)
                    }

                    HStack {
                        Text("Total Debe:")
                            .font(.headline)
                        Spacer()
                        Text("\(NSDecimalNumber(decimal: totalDebit).doubleValue, specifier: "%.2f")")
                            .font(.headline).bold()
                        Image(systemName: "square.and.arrow.down.on.square")
                    }.padding(.vertical, 5)
                }

                // MARK: - Haber
                Section(header: Text("Haber")) {
                    ForEach(accountingEntries.filter { $0.creditAmount > 0 }) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(entry.account.name)
                                    Spacer()
                                    Text("\(NSDecimalNumber(decimal: entry.creditAmount).doubleValue, specifier: "%.2f")")
                                }
                            }
                            Spacer()
                            Button {
                                accountingEntries.removeAll { $0.id == entry.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }.buttonStyle(BorderlessButtonStyle())
                        }.padding(.vertical, 5)
                    }

                    HStack {
                        Text("Total Haber:")
                            .font(.headline)
                        Spacer()
                        Text("\(NSDecimalNumber(decimal: totalCredit).doubleValue, specifier: "%.2f")")
                            .font(.headline).bold()
                        Image(systemName: "square.and.arrow.up.on.square")
                    }.padding(.vertical, 5)
                }

                // MARK: - Transacción y Confirmación
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

                    Picker("Tipo de asiento", selection: $selectedValue) {
                        ForEach(opciones, id: \.valor) { opcion in
                            Text(opcion.nombre).tag(opcion.valor)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section {
                    Button(action: {
                        Task {
                            let details = accountingEntries.map {
                                AccountingEntryDetailRequest(
                                    accountingAccountId: $0.account.id,
                                    debitAmount: NSDecimalNumber(decimal: $0.debitAmount).doubleValue,
                                    creditAmount: NSDecimalNumber(decimal: $0.creditAmount).doubleValue
                                )
                            }

                            let request = AccountingEntryRequest(
                                description: accountReference.isEmpty ? "asiento por defecto" : accountReference,
                                breed: selectedValue,
                                Date: nil,
                                Projection: false,
                                TransactionId: nil,
                                accountingEntryDetails: details
                            )

                            await createEntryViewModel.createAccountingEntry(acocuntingEntry: request)
                            if createEntryViewModel.result != nil {
                                withAnimation {
                                    showToast = true
                                }
                                accountingEntries.removeAll()
                                accountReference = ""

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }) {
                        HStack {
                            Text("Confirmar Transacción")
                            Spacer()
                            Image(systemName: "square.and.arrow.down.on.square.fill")
                        }
                    }
                    .disabled(!isConfirmEnabled || createEntryViewModel.isLoading)
                }
            }

            // MARK: - Toast Popup
            if showToast {
                VStack {
                    Spacer()
                    Text("Registro ingresado correctamente")
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3).ignoresSafeArea())
                .transition(.opacity)
            }
        }
        .navigationTitle("Registro Contable")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Vista previa
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountingEntryCreateView()
    }
}
