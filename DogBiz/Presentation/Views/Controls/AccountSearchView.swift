//
//  AccountSearchView.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 25/5/25.
//

import SwiftUI

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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
