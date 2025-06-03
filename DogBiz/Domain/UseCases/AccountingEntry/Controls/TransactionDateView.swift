import SwiftUI

struct TransactionDateView: View {
    let transactionDate: Date

    // DateFormatter estático para mejorar rendimiento y evitar crear uno nuevo en cada render
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        Text(Self.dateFormatter.string(from: transactionDate))
            .font(.headline)
    }
}
struct TransactionDateView_Previews: PreviewProvider {
    static var previews: some View {
        // Crear un Date desde String ISO8601 con fracciones
        let isoString = "2025-05-22T16:50:24.0166306"
        let date = ISO8601DateFormatter().date(from: isoString) ?? Date()

        TransactionDateView(transactionDate: date)
    }
}
