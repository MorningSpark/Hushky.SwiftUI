import SwiftUI

struct ProyeccionFormularioView: View {
    @State private var fecha = Date()
    @State private var cuentaId = ""
    @State private var esProyeccion = false

    var body: some View {
        Form {
            Section(header: Text("Datos del Formulario")) {
                DatePicker("Fecha", selection: $fecha, displayedComponents: .date)

                TextField("ID de Cuenta", text: $cuentaId)
                    .keyboardType(.numberPad)

                Toggle("¿Es Proyección?", isOn: $esProyeccion)
            }

            Section {
                Button("Guardar") {
                    // Aquí podrías manejar el envío de datos
                    print("Fecha: \(fecha)")
                    print("ID Cuenta: \(cuentaId)")
                    print("Es Proyección: \(esProyeccion)")
                }
            }
        }
        .navigationTitle("Formulario")
    }
}

#Preview {
    NavigationView {
        ProyeccionFormularioView()
    }
}
