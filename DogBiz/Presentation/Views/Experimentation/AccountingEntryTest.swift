import SwiftUI

// MARK: - Modelo de cuenta contable
struct AccountItem: Identifiable, Codable {
    let id: Int
    let parentId: Int
    let referenceCode: String
    let reference: String
    let name: String
    let resource: String?
    let referenceValue: Double?
    let creationDate: String
    let alterDate: String?
}

// MARK: - Modelo de entrada contable
struct AccountingEntry: Identifiable {
    let id = UUID()
    let account: AccountItem
    let debitAmount: Double
    let creditAmount: Double
}

struct AccountingEntryRequest: Codable {
    let description: String
    let TypeAccount: Int
    let Date: String
    let Projection: Bool
    let TransactionId: Int?
    let accountingEntryDetails: [AccountingEntryDetail]
}

struct AccountingEntryDetail: Codable {
    let accountingAccountId: Int
    let debitAmount: Double
    let creditAmount: Double
}


// MARK: - Datos simulados
let mockAccounts: [AccountItem] = [
    AccountItem(id: 5, parentId: 0, referenceCode: "5", reference: "Patrimonio", name: "Patrimonio", resource: nil, referenceValue: nil, creationDate: "2025-05-20T02:34:40.52", alterDate: nil),
    AccountItem(id: 6, parentId: 5, referenceCode: "5.01", reference: "Capital Social", name: "Capital Social", resource: nil, referenceValue: nil, creationDate: "2025-05-20T03:00:00.00", alterDate: nil),
    AccountItem(id: 7, parentId: 6, referenceCode: "5.01.01", reference: "Aportaciones", name: "Aportaciones", resource: nil, referenceValue: nil, creationDate: "2025-05-20T03:15:00.00", alterDate: nil),
    AccountItem(id: 12, parentId: 1, referenceCode: "1.01", reference: "Banco Produbanco", name: "Banco Produbanco", resource: nil, referenceValue: nil, creationDate: "2025-05-21T10:00:00.00", alterDate: nil)
]

// MARK: - Vista Principal
struct AccountingEntryTest: View {
    @State private var selectedAccount: AccountItem?
    @State private var accountValue = ""
    @State private var accountType = "Crédito"
    @State private var accountReference = ""
    @State private var accountingEntries: [AccountingEntry] = []
    @State private var showAccountSearch = false

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
        NavigationView {
            Form {
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
                        AccountSearchView(accounts: mockAccounts) { account in
                            selectedAccount = account
                        }
                    }

                    TextField("Valor", text: $accountValue)
                        .keyboardType(.decimalPad)

                    HStack {
                        Picker("Tipo", selection: $accountType) {
                            Text("Crédito").tag("Crédito")
                            Text("Débito").tag("Débito")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button {
                            let formattedValue = accountValue.replacingOccurrences(of: ",", with: ".")
                            if let amount = Double(formattedValue), let account = selectedAccount {
                                let entry = AccountingEntry(
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

                Section(header: Text("Finalizar Transacción")) {
                    TextEditor(text: $accountReference)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.vertical, 5)

                    Button("Confirmar") {
                        let details = accountingEntries.map {
                                AccountingEntryDetail(
                                    accountingAccountId: $0.account.id,
                                    debitAmount: $0.debitAmount,
                                    creditAmount: $0.creditAmount
                                )
                            }
                        let request = AccountingEntryRequest(
                                description: accountReference.isEmpty ? "Estado de situacion inicial" : accountReference,
                                TypeAccount: 0,
                                Date: "2025-05-01", // o usa DateFormatter para la fecha actual si prefieres
                                Projection: false,
                                TransactionId: nil,
                                accountingEntryDetails: details
                            )
                        print(request)
                        // Aquí puedes codificar y enviar a tu backend si lo deseas
                    }
                    .disabled(!isConfirmEnabled)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Registro Contable")
        }
    }
}

// MARK: - Vista de búsqueda de cuentas
struct AccountSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    let accounts: [AccountItem]
    let onSelect: (AccountItem) -> Void

    var filteredAccounts: [AccountItem] {
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
        AccountingEntryTest()
    }
}
