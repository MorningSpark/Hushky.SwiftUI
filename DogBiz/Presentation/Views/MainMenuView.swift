import SwiftUI

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Opciones principales").padding(.top, 0)) {
                    NavigationLink(destination: ResumeBalanceView()) {
                        Label("Mayor general", systemImage: "doc.plaintext")
                    }

                    NavigationLink(destination: AccountingEntryCreateView()) {
                        Label("Registrar Asiento", systemImage: "square.and.pencil")
                    }
                }
                
                Section(header: Text("Transacciones").padding(.top, 0)) {
                    NavigationLink(destination: CreateTransactionView()) {
                        Label("Crear transaccion", systemImage: "document.badge.gearshape")
                    }
                }
            }
            .listStyle(.insetGrouped) // Opcional, para mejor estilo visual
            .navigationTitle("Menú Principal")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct XContentView: View {
    @State private var selectedTab = 0
    @State private var viewIDs: [UUID] = [UUID(), UUID(), UUID()]

    var body: some View {
        TabView(selection: $selectedTab) {
            MainMenuView()
                .id(viewIDs[0])
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Menú")
                }
                .tag(0)

            NavigationView {
                ResumeBalanceView()
                    .navigationTitle("Balance")
            }
            .id(viewIDs[1])
            .tabItem {
                Image(systemName: "doc.plaintext")
                Text("Balance")
            }
            .tag(1)

            NavigationView {
                AccountingEntryCreateView()
                    .navigationTitle("Asientos")
            }
            .id(viewIDs[2])
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Asientos")
            }
            .tag(2)
        }
        .onChange(of: selectedTab) {
            viewIDs[selectedTab] = UUID()
        }
    }
}




// Previews
struct XContentView_Previews: PreviewProvider {
    static var previews: some View {
        XContentView()
    }
}
