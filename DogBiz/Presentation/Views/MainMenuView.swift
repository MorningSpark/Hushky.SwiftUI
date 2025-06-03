import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Opciones principales").padding(.top, 0)) {
                    NavigationLink(destination: ResumeBalanceView()) {
                        Label {
                            Text("Mayor general") // This text will keep its default color
                        } icon: {
                            Image(systemName: "doc.plaintext.fill")
                                .foregroundColor(.red) // Only the icon will be yellow
                        }
                    }

                    NavigationLink(destination: AccountingEntryCreateView()) {
                        Label {
                            Text("Registrar Asiento") // This text will keep its default color
                        } icon: {
                            Image(systemName: "document.badge.gearshape.fill")
                                .foregroundColor(.green) // Only the icon will be yellow
                        }
                        
                    }
                    NavigationLink(destination: DayBookView()) {
                        Label("Libro diario", systemImage: "book.pages.fill")
                    }
                }
            }
            .listStyle(.insetGrouped) // Opcional, para mejor estilo visual
            .navigationTitle("Menú")
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
                DayBookView()
                    .navigationTitle("Asientos")
            }
            .id(viewIDs[2])
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Diario")
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
