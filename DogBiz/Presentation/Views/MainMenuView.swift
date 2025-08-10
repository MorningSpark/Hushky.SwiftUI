import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Opciones principales").padding(.top, 0)) {
                    NavigationLink(destination: ResumeBalanceView()) {
                        Label {
                            Text("Mayor general")
                        } icon: {
                            Image(systemName: "doc.plaintext.fill")
                                .foregroundColor(.red)
                        }
                    }

                    NavigationLink(destination: AccountingEntryCreateView()) {
                        Label {
                            Text("Registrar Asiento")
                        } icon: {
                            Image(systemName: "document.badge.gearshape.fill")
                                .foregroundColor(.green)
                        }
                    }

                    NavigationLink(destination: DayBookView()) {
                        Label("Libro diario", systemImage: "book.pages.fill")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Menú") // Mantiene el título grande en MainMenuView
            .navigationBarTitleDisplayMode(.large) // Asegura el título grande
        }
    }
}

struct XContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MainMenuView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Menú")
                }
                .tag(0)

            NavigationView {
                DashboardView()
                    .navigationTitle("DashBoard")
                   
            }
            .tabItem {
                Image(systemName: "doc.plaintext")
                Text("DashBoard")
            }
            .tag(1)

            NavigationView {
                DayBookView()
                    .navigationTitle("Asientos")
                    .navigationBarTitleDisplayMode(.inline) // Título normal en otras vistas
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Diario")
            }
            .tag(2)
        }
    }
}

// Previews
struct XContentView_Previews: PreviewProvider {
    static var previews: some View {
        XContentView()
    }
}
