import SwiftUI
import Charts

struct FinancialData: Identifiable, Equatable {
    let id: UUID
    let category: String
    let value: Double
}

struct Movement: Identifiable {
    let id = UUID()
    let parentId: UUID
    let description: String
    let amount: Double
}

struct DashboardView: View {
    let initialDateScope: Date
    let endDateScope: Date
    let proyeccionScope: Bool
    
    @StateObject private var viewModel = AccountSummaryViewModel(
        useCase: FetchAccountSummaryUseCase(
            repository: AccountingAccountRepository(networkService: NetworkService())
        )
    )

    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let initialDate = dateFormatter.date(from: "2025-05-01") ?? Date()
        let endDate = Date()
        self.initialDateScope = initialDate
        self.endDateScope = endDate
        self.proyeccionScope = false
    }
    
    @State private var selectedAccount: AccountingAccountSumary?
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func rootAccounts() -> [AccountingAccountSumary] {
        viewModel.summaries.filter { ($0.configuration & 1 != 0) && $0.balance != 0 }
    }
    
    func rootAccountsGeneral() -> [AccountingAccountSumary] {
        viewModel.summaries.filter { ($0.level == 1) }
    }
    
    func rootAccountsGeneral(filtro:Int) -> [AccountingAccountSumary] {
        viewModel.summaries.filter { ($0.configuration & filtro != 0) }
    }

    private func calculateTotals() -> [(label: String, value: Double, color: Color)] {
        let positiveSum = rootAccounts().filter { $0.balance >= 0 }.map { $0.balance }.reduce(0, +)
        let negativeSum = rootAccounts().filter { $0.balance < 0 }.map { abs($0.balance) }.reduce(0, +)

        return [
            ("Entradas", positiveSum, .green),
            ("Salidas", negativeSum, .red)
        ]
    }
    
    private func getTotalValue()->Double{
        let positiveSum = rootAccounts().filter { $0.balance >= 0 }.map { $0.balance }.reduce(0, +)
        let negativeSum = rootAccounts().filter { $0.balance < 0 }.map { abs($0.balance) }.reduce(0, +)
        return positiveSum - negativeSum
    }
    
    
    
    private func maxYValue() -> Double {
        let maxValue = rootAccounts().map { abs($0.balance) }.max() ?? 100
        return ceil(maxValue / 10) * 100
    }

    private func yStride() -> Double {
        let maxValue = maxYValue()
        return max(10, ceil(maxValue / 5))
    }

    var body: some View {
        Form {
            Section(header: Text("Balance Prioritario")) {
                VStack(alignment: .leading) {
                    Text("Resumen Financiero")
                        .font(.title)
                        .padding(.horizontal)
                    Divider().padding(.vertical, 8)

                    HStack {
                        // Tu gráfico de pastel
                        Chart {
                            let totals = calculateTotals()
                            let totalValue = totals.map { $0.value }.reduce(0, +)

                            ForEach(totals, id: \.label) { item in
                                SectorMark(
                                    angle: .value("Valor", item.value),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(item.color)
                                .annotation(position: .overlay) {
                                    let percentage = totalValue > 0 ? item.value / totalValue * 100 : 0
                                    Text(String(format: "%.1f%%", percentage))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal)

                        // Leyendas
                        let totals = calculateTotals()
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(totals, id: \.label) { item in
                                HStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 12, height: 12)
                                    Text(item.label)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }

                    
                    
                   
                    Divider().padding(.vertical, 8)
                    
                    
                    

                    // Segundo gráfico: Circular con porcentajes
                    Text("Resumen Cuentas Prioritarias")
                        .font(.headline)
                        .padding(.horizontal)
                    HStack(){
                        Text("Total General:")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        Text(String(format: "$%.2f", getTotalValue()))
                            .foregroundColor(.gray)
                    }
                    // Primer gráfico: Barras
                    Chart {
                        ForEach(rootAccounts()) { financialDataItem in
                            BarMark(
                                x: .value("Categoría", financialDataItem.name),
                                y: .value("Valor", abs(financialDataItem.balance))
                            )
                            .foregroundStyle(getBarColor(for: financialDataItem))
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    .chartOverlay { proxy in
                        GeometryReader { geo in
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onEnded { value in
                                            let location = value.location
                                            if let (category, _) = proxy.value(at: location, as: (String, Double).self) {
                                                if let tapped = rootAccounts().first(where: { $0.name == category }) {
                                                    if selectedAccount?.id == tapped.id {
                                                        selectedAccount = nil
                                                    } else {
                                                        selectedAccount = tapped
                                                    }
                                                }
                                            }
                                        }
                                )
                        }
                    }

                    

                    Divider().padding(.vertical, 8)

                    if let selected = selectedAccount {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(selected.name)")
                                .font(.headline)
                                .padding(.horizontal)

                            HStack {
                                Text("Valor Total")
                                Spacer()
                                Text(String(format: "$%.2f", selected.balance))
                                    .foregroundColor(selected.balance >= 0 ? .green : .red)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)
                    } else {
                        Text("Selecciona una categoría para ver sus movimientos.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .refreshable {
                    await viewModel.loadSummaries(
                        initialDate: formatDate(initialDateScope),
                        endDate: formatDate(endDateScope),
                        projection: proyeccionScope,
                        absoluteBalance: true
                    )
                }
                .alert(isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? ""),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .task {
                    await viewModel.loadSummaries(
                        initialDate: formatDate(initialDateScope),
                        endDate: formatDate(endDateScope),
                        projection: proyeccionScope,
                        absoluteBalance: true
                    )
                }
            }
            Section(header: Text("Balance general")) {
                VStack(alignment: .leading) {
                    Text("Cuentas Generales")
                        .font(.title)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(rootAccountsGeneral()) { financialDataItem in
                            BarMark(
                                x: .value("Categoría", financialDataItem.name),
                                y: .value("Valor", abs(financialDataItem.balance))
                            )
                            .foregroundStyle(getBarColor(for: financialDataItem))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .stride(by: yStride())) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    
                    Divider().padding(.vertical, 8)
                    
                    // Lista de cuentas generales
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(rootAccountsGeneral()) { account in
                            HStack {
                                Text(account.name)
                                    .font(.subheadline)
                                Spacer()
                                Text(String(format: "$%.2f", account.balance))
                                    .foregroundColor(account.balance >= 0 ? .green : .red)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Total general
                        HStack {
                            Text("Balance de comprobacion:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "$%.2f", rootAccountsGeneral().map { $0.balance }.reduce(0, +)))
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                    
                    Divider().padding(.vertical, 8)
                    
                    HStack {
                        Text("Activo - Pasivo:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "$%.2f", rootAccountsGeneral(filtro:2).map { $0.balance }.reduce(0, +)))
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                    
                    Divider().padding(.vertical, 8)
                    
                    Text("Resumen general de todas las cuentas de primer nivel")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .refreshable {
                    await viewModel.loadSummaries(
                        initialDate: formatDate(initialDateScope),
                        endDate: formatDate(endDateScope),
                        projection: proyeccionScope,
                        absoluteBalance: true
                    )
                }
                .alert(isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? ""),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .task {
                    await viewModel.loadSummaries(
                        initialDate: formatDate(initialDateScope),
                        endDate: formatDate(endDateScope),
                        projection: proyeccionScope,
                        absoluteBalance: true
                    )
                }
            }
            
        }
    }

    private func getBarColor(for item: AccountingAccountSumary) -> Color {
        if selectedAccount?.id == item.id {
            return item.balance >= 0 ? .green.opacity(0.6): .red.opacity(0.6)
        } else {
            return item.balance >= 0 ? .green : .red
        }
    }
}

struct PPContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
