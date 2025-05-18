import SwiftUI

// MARK: - Modelo
struct Cuenta: Identifiable, Equatable {
    let id: String
    let nombre: String
}

// MARK: - Pantalla Principal
struct FormularioView: View {
    @State private var cuentaSeleccionada: Cuenta?
    @State private var fechaInicial: Date = Date()
    @State private var fechaFinal: Date = Date()
    @State private var esProyeccion: Bool = false
    @State private var mostrarBusqueda: Bool = false
    @State private var mostrarResultado: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Cuenta")) {
                    HStack {
                        Text(cuentaSeleccionada != nil
                             ? "\(cuentaSeleccionada!.id) - \(cuentaSeleccionada!.nombre)"
                             : "Seleccionar cuenta")
                            .foregroundColor(cuentaSeleccionada == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mostrarBusqueda = true
                    }
                }

                Section(header: Text("Fechas y Tipo")) {
                    DatePicker("Fecha inicial", selection: $fechaInicial, displayedComponents: .date)
                    DatePicker("Fecha final", selection: $fechaFinal, displayedComponents: .date).datePickerStyle(.compact)
                    Toggle("¿Es proyección?", isOn: $esProyeccion)
                }

                Section {
                    Button("Ir a resultado") {
                        if cuentaSeleccionada != nil {
                            mostrarResultado = true
                        }
                    }
                    .disabled(cuentaSeleccionada == nil)
                }
            }
            .navigationTitle("Formulario de Cuenta")
            .sheet(isPresented: $mostrarBusqueda) {
                BusquedaCuentaView(cuentaSeleccionada: $cuentaSeleccionada)
            }
            .navigationDestination(isPresented: $mostrarResultado) {
                ResultadoView(
                    accountId: cuentaSeleccionada?.id ?? "",
                    fechaInicial: fechaInicial,
                    fechaFinal: fechaFinal,
                    esProyeccion: esProyeccion
                )
            }
        }
    }
}

// MARK: - Pantalla de Búsqueda
struct BusquedaCuentaView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var cuentaSeleccionada: Cuenta?

    @State private var buscarTexto: String = ""
    
    private let cuentas: [Cuenta] = [
        Cuenta(id: "1001", nombre: "Caja General"),
        Cuenta(id: "1002", nombre: "Banco Nación"),
        Cuenta(id: "1003", nombre: "Cuentas por Cobrar"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
        Cuenta(id: "2001", nombre: "Provisión de Sueldos"),
    ]

    var cuentasFiltradas: [Cuenta] {
        if buscarTexto.isEmpty {
            return cuentas
        } else {
            return cuentas.filter {
                $0.nombre.localizedCaseInsensitiveContains(buscarTexto) ||
                $0.id.contains(buscarTexto)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(cuentasFiltradas) { cuenta in
                Button {
                    cuentaSeleccionada = cuenta
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(cuenta.nombre)
                        Text("ID: \(cuenta.id)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .searchable(text: $buscarTexto, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Buscar Cuenta")
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

// MARK: - Pantalla de Resultado
struct ResultadoView: View {
    let accountId: String
    let fechaInicial: Date
    let fechaFinal: Date
    let esProyeccion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ID de Cuenta: \(accountId)")
            Text("Fecha Inicial: \(fechaInicial.formatted(date: .abbreviated, time: .omitted))")
            Text("Fecha Final: \(fechaFinal.formatted(date: .abbreviated, time: .omitted))")
            Text("¿Es proyección?: \(esProyeccion ? "Sí" : "No")")
        }
        .padding()
        .navigationTitle("Resultado")
    }
}

// MARK: - Preview
struct CreateTransactionView: View {
    var body: some View {
        FormularioView()
    }
}

#Preview {
    CreateTransactionView()
}
