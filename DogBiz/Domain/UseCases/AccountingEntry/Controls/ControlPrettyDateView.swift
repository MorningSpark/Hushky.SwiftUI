import SwiftUI

struct ControlPrettyDateView: View {
    @Binding var fechaInicial: Date
    @Binding var fechaFinal: Date
    @State private var mostrarCalendarioInicial = false
    @State private var mostrarCalendarioFinal = false

    var body: some View {
        Group {
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
                .onChange(of: fechaInicial) { _, _ in
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
                .onChange(of: fechaFinal) { _, _ in
                    withAnimation {
                        mostrarCalendarioFinal = false
                    }
                }
            }
        }
    }
}
