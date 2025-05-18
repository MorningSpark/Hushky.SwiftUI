import SwiftUI

struct ResumeBalanceView: View {
    @State private var fechaInicial: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 1)) ?? Date()
    @State private var fechaFinal: Date = Date()
    @State private var esProyeccion: Bool = false
    @State private var mostrarDetalle = false
    
    @State private var mostrarFechaInicial = false
    @State private var mostrarFechaFinal = false
    
    @State private var mostrarCalendarioInicial = false
    @State private var mostrarCalendarioFinal = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Paramtros iniciales")) {
                    
                    // Fecha Inicial
                    Button {
                        mostrarCalendarioFinal = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    mostrarCalendarioInicial.toggle()
                                }
                            }
                    } label: {
                        HStack {
                            Text("Fecha inicial:")
                                .foregroundColor(.gray)  // Texto gris
                            Spacer()
                            Text(fechaInicial.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(.plain)  // Sin estilo azul

                    if mostrarCalendarioInicial {
                        DatePicker(
                            "",
                            selection: $fechaInicial,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .transition(.opacity)
                        .onChange(of: fechaInicial) { newValue, oldValue in
                            withAnimation {
                                mostrarCalendarioInicial = false
                            }
                        }
                    }

                    // Fecha Final
                    Button {
                        mostrarCalendarioInicial = false

                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                                withAnimation {
                                                    mostrarCalendarioFinal.toggle()
                                                }
                                            }
                    } label: {
                        HStack {
                            Text("Fecha final:")
                                .foregroundColor(.gray)  // Texto gris
                            Spacer()
                            Text(fechaFinal.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(.plain)  // Sin estilo azul

                    if mostrarCalendarioFinal {
                        DatePicker(
                            "",
                            selection: $fechaFinal,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .transition(.opacity)
                        .onChange(of: fechaFinal) { newValue, oldValue in
                            withAnimation {
                                mostrarCalendarioFinal = false
                            }
                        }
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
