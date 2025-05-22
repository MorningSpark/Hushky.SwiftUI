import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ResumeBalanceView()) {
                    Label("Mayor general", systemImage: "doc.plaintext")
                }

                NavigationLink(destination: AccountingEntryCreateView()) {
                    Label("Registrar Asiento", systemImage: "square.and.pencil")
                }
            }
            .navigationTitle("Menú Principal")
        }
    }
}

// Previews
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
