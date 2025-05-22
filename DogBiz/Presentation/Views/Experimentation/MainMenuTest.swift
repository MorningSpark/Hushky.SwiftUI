import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ResumeBalanceView()) {
                    Label("Mayor general", systemImage: "doc.plaintext")
                }

                NavigationLink(destination: AccountingEntryTest()) {
                    Label("Registrar Asiento", systemImage: "square.and.pencil")
                }
            }
            .navigationTitle("Menú Principal")
        }
    }
}

// Segundo nivel: Reportes
struct ReportesMenuView: View {
    var body: some View {
        List {
            NavigationLink(destination: ReportesFinancierosMenuView()) {
                Label("Financieros", systemImage: "doc.text.magnifyingglass")
            }
        }
        .navigationTitle("Reportes")
    }
}

// Tercer nivel: Reportes Financieros
struct ReportesFinancierosMenuView: View {
    var body: some View {
        List {
            NavigationLink(destination: BalanceGeneralView()) {
                Label("Balance General", systemImage: "chart.bar.doc.horizontal")
            }
            NavigationLink(destination: EstadoResultadosView()) {
                Label("Estado de Resultados", systemImage: "chart.pie.fill")
            }
        }
        .navigationTitle("Financieros")
    }
}

// Pantallas finales
struct BalanceGeneralView: View {
    var body: some View {
        Text("Pantalla de Balance General")
            .font(.title)
            .padding()
    }
}

struct EstadoResultadosView: View {
    var body: some View {
        Text("Pantalla de Estado de Resultados")
            .font(.title)
            .padding()
    }
}

struct RegistrarDiarioView: View {
    var body: some View {
        Text("Pantalla de Registro Diario")
            .font(.title)
            .padding()
    }
}

// Previews
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
