import SwiftUI

struct ResumeBalanceView: View {
    @State private var fechaInicial: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1)) ?? Date()
    @State private var fechaFinal: Date = Date()
    @State private var esProyeccion: Bool = false
    @State private var mostrarDetalle = false

    var body: some View {
        
            Form {
                Section(header: Text("Parametros iniciales")) {
                    ControlPrettyDateView(fechaInicial: $fechaInicial, fechaFinal: $fechaFinal)
                    Toggle("¿Es proyección?", isOn: $esProyeccion)
                }
                
                NavigationLink(destination: ContentView(initialDateScope: fechaInicial, endDateScope: fechaFinal, proyeccionScope: esProyeccion)) {
                    Label("Estado de Resultados", systemImage: "chart.pie.fill")
                }
            }.navigationTitle("Mayor General")
        
    }
}

#Preview {
    ResumeBalanceView()
}
