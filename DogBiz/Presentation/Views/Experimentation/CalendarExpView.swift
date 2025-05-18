import SwiftUI

struct FechaExpandibleView: View {
    @State private var fechaInicial = Date()
    @State private var fechaFinal = Date()
    @State private var mostrarCalendarioInicial = false
    @State private var mostrarCalendarioFinal = false

    var body: some View {
        Form {
            Section(header: Text("Fecha Inicial")) {
                Button {
                    // Primero cierro el otro calendario
                    mostrarCalendarioFinal = false
                    
                    // Pequeño delay antes de togglear este calendario
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            mostrarCalendarioInicial.toggle()
                        }
                    }
                } label: {
                    HStack {
                        Text("Fecha inicial:")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(fechaInicial.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)

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
            }

            Section(header: Text("Fecha Final")) {
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
                            .foregroundColor(.gray)
                        Spacer()
                        Text(fechaFinal.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)

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
            }

            Text("Presiona el botón para ver la fecha seleccionada")
        }
        .navigationTitle("Fecha Expandible")
    }
}

#Preview {
    NavigationView {
        FechaExpandibleView()
    }
}
