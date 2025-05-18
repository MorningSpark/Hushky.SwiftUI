import SwiftUI

struct ResumeBalanceView: View {
    @State private var fechaInicial: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1)) ?? Date()
    @State private var fechaFinal: Date = Date()
    @State private var esProyeccion: Bool = false
    @State private var mostrarDetalle = false
    
    @State private var mostrarFechaInicial = false
    @State private var mostrarFechaFinal = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Fechas y Tipo")) {
                    
                    HStack {
                        Text("Fecha inicial")
                        Spacer()
                        Text(fechaInicial, style: .date)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mostrarFechaInicial = true
                    }

                    HStack {
                        Text("Fecha final")
                        Spacer()
                        Text(fechaFinal, style: .date)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mostrarFechaFinal = true
                    }

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
            .navigationTitle("Formulario de Cuenta")
            .navigationDestination(isPresented: $mostrarDetalle) {
                ContentView(initialDateScope: fechaInicial, endDateScope: fechaFinal, proyeccionScope: esProyeccion)
            }
            .sheet(isPresented: $mostrarFechaInicial) {
                VStack {
                    DatePicker("Selecciona fecha inicial", selection: $fechaInicial, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Button("Aceptar") {
                        mostrarFechaInicial = false
                    }
                    .padding()
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $mostrarFechaFinal) {
                VStack {
                    DatePicker("Selecciona fecha final", selection: $fechaFinal, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Button("Aceptar") {
                        mostrarFechaFinal = false
                    }
                    .padding()
                }
                .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ResumeBalanceView()
}
