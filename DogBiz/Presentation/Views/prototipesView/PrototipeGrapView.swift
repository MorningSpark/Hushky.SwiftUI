import SwiftUI
import Charts

struct FinancialDataPrototipe: Identifiable, Equatable {
    let id: UUID
    let category: String
    let value: Double
}

struct MovementPrototipe: Identifiable {
    let id = UUID()
    let parentId: UUID
    let description: String
    let amount: Double
}

struct PrototipeGrapView: View {
    let data: [FinancialData]
    let allMovements: [Movement]

    init() {
        let banco = FinancialData(id: UUID(), category: "Banco", value: 5000)
        let cuentas = FinancialData(id: UUID(), category: "Cuentas por pagar", value: 2000)
        let ingresos = FinancialData(id: UUID(), category: "Ingresos", value: 7000)
        let gastos = FinancialData(id: UUID(), category: "Gastos", value: 3000)
        let impuestos = FinancialData(id: UUID(), category: "Impuestos y otros", value: 1500)
        let mantenimiento = FinancialData(id: UUID(), category: "Mantenimiento", value: 1200)

        self.data = [banco, cuentas, ingresos, gastos, impuestos, mantenimiento]

        self.allMovements = [
            Movement(parentId: banco.id, description: "Depósito inicial", amount: 3000),
            Movement(parentId: banco.id, description: "Transferencia recibida", amount: 2000),
            Movement(parentId: cuentas.id, description: "Pago proveedor A", amount: -1000),
            Movement(parentId: cuentas.id, description: "Pago proveedor B", amount: -1000),
            Movement(parentId: ingresos.id, description: "Venta producto X", amount: 4000),
            Movement(parentId: ingresos.id, description: "Servicio prestado Y", amount: 3000),
            Movement(parentId: gastos.id, description: "Compra insumos", amount: -1500),
            Movement(parentId: gastos.id, description: "Pago servicios", amount: -1500),
            Movement(parentId: impuestos.id, description: "Impuesto IVA", amount: -1000),
            Movement(parentId: impuestos.id, description: "Otros cargos", amount: -500),
            Movement(parentId: mantenimiento.id, description: "Reparación equipo", amount: -1200)
        ]
    }

    @State private var selectedCategory: FinancialData?

    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Resumen Financiero")
                    .font(.title)
                    .padding(.horizontal)

                Chart(data) { financialDataItem in
                    BarMark(
                        x: .value("Categoría", financialDataItem.category),
                        y: .value("Valor", financialDataItem.value)
                    )
                    .foregroundStyle(getBarColor(for: financialDataItem))
                    .annotation(position: .top, alignment: .center, spacing: 4) {
                        if selectedCategory == financialDataItem {
                            Text(String(format: "%.0f", financialDataItem.value))
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.8))
                                        .shadow(radius: 2)
                                )
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: Array(stride(from: 0, to: 10000, by: 1000))) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                if let plotFrame = proxy.plotFrame {
                                    let xLocation = location.x - geometry[plotFrame].origin.x
                                    let yLocation = location.y - geometry[plotFrame].origin.y

                                    if let (category, _) = proxy.value(at: CGPoint(x: xLocation, y: yLocation), as: (String, Double).self),
                                       let tappedDataItem = data.first(where: { $0.category == category }) {
                                        selectedCategory = (selectedCategory == tappedDataItem) ? nil : tappedDataItem
                                    }
                                }
                            }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)

                Divider().padding(.vertical, 8)

                if let selected = selectedCategory {
                    let filteredMovements = allMovements.filter { $0.parentId == selected.id }

                    if filteredMovements.isEmpty {
                        Text("No hay movimientos para '\(selected.category)'.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Movimientos de '\(selected.category)'")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(filteredMovements) { movement in
                                HStack {
                                    Text(movement.description)
                                    Spacer()
                                    Text(String(format: "%.2f", movement.amount))
                                        .foregroundColor(movement.amount >= 0 ? .green : .red)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom)
                    }
                } else {
                    Text("Selecciona una categoría para ver sus movimientos.")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
        }
    }

    private func getBarColor(for item: FinancialData) -> Color {
        if selectedCategory == item {
            return .blue.opacity(0.6)
        } else {
            return item.value >= 0 ? .green : .red
        }
    }
}

struct PrototipeView_Previews: PreviewProvider {
    static var previews: some View {
        PrototipeGrapView()
    }
}
