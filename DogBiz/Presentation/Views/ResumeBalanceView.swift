import SwiftUI

struct ResumeBalanceView: View {
    @State private var fechaInicial: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1)) ?? Date()
    @State private var fechaFinal: Date = Date()
    @State private var esProyeccion: Bool = false
    @State private var mostrarDetalle = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Paramtros iniciales")) {
                    ControlPrettyDateView(fechaInicial: $fechaInicial, fechaFinal: $fechaFinal)
                    Toggle("¿Es proyección?", isOn: $esProyeccion)
                }

                Section {
                    Button("Ir a resultado") {
                        mostrarDetalle = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }.listRowInsets(EdgeInsets())
            }
            .navigationTitle("Balance Cuentas")
            .navigationDestination(isPresented: $mostrarDetalle) {
                ContentView(initialDateScope: fechaInicial, endDateScope: fechaFinal, proyeccionScope: esProyeccion)
            }
        }
    }
}

#Preview {
    ResumeBalanceView()
}
