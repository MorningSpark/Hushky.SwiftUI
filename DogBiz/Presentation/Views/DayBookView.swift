import SwiftUI

struct DayBookView: View {
    @StateObject private var viewModel = DayBookViewModel(
        useCase: FetchAccountingEntryRangeUseCase(
            repository: AccountingEntryRepository(networkService: NetworkService())),
        deleteAccountingEntryuseCase: DeleteAccountingEntryUseCase(
                repository: AccountingEntryRepository(networkService: NetworkService()))
    )
    @State private var showConfirmation = false
    @State private var transactionToDelete: AccountingEntry?
    @State private var searchText = ""

    var filteredTransactions: [AccountingEntry] {
        if searchText.isEmpty {
            return viewModel.accountingEntries
        } else {
            return viewModel.accountingEntries.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Filtro de asientos")){
                // Campo de búsqueda con ícono de lupa y sin bordes
                HStack {
                    TextField("Buscar por descripción...", text: $searchText)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            Section(header: Text("Asientos")) {
                List(filteredTransactions, id: \.id) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            TransactionDateView(transactionDate: transaction.creationDate).font(.headline)
                            Text("\(transaction.description)").font(.subheadline).foregroundColor(.gray)
                        }
                        Spacer()
                        Text(String(format: "%.2f$", abs(transaction.referenceValue))).font(.footnote)
                            .foregroundColor(.gray)
                        Button(action: {
                            print("pendiente")
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            transactionToDelete = transaction
                            showConfirmation = true
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.accountingEntries.isEmpty {
                ProgressView()
            }
        }
        .refreshable {
            await viewModel.loadAccountingEntries()
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
        .task {
            await viewModel.loadAccountingEntries()
            await viewModel.sortLedgersByDateDescending()
        }
        .confirmationDialog("¿Estás seguro de que deseas eliminar este registro?", isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Eliminar", role: .destructive) {
                if let transactionToDelete = transactionToDelete {
                    deleteTransaction(transactionToDelete.id)
                }
            }
            Button("Cancelar", role: .cancel) {}
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Libro Diario")
        .navigationBarBackButtonHidden(false)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                                NavigationLink(destination: AccountingEntryCreateView()) {
                                    Label("Mayor general", systemImage: "document.badge.plus")
                                }
                            
                        }
                    }
    }

    private func deleteTransaction(_ id: Int) {
        Task{
            await viewModel.deleteAccountingEntry(accountingEntryId: String(id))
            await viewModel.loadAccountingEntries()
            await viewModel.sortLedgersByDateDescending()
            print("Registro eliminado: ID \(id)")
        }
        
    }
}

struct ContentView_Previewsx: PreviewProvider {
    static var previews: some View {
        DayBookView()
    }
}
