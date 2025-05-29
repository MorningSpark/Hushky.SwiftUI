import SwiftUI

struct Transaction: Identifiable {
    let id = UUID()
    let cuenta: String
    let debe: Double
    let haber: Double
}

struct ControlTableView: View {
    let transactions: [Transaction] = [
        Transaction(cuenta: "Caja", debe: 500.0, haber: 0.0),
        Transaction(cuenta: "Banco", debe: 0.0, haber: 300.0),
    ]

    var body: some View {
        Form{
            VStack(spacing: 0) {
                // Encabezado con estilo
                HStack {
                    Text("Cuenta").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("Debe").bold().frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Haber").bold().frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .background(Color.blue.opacity(0.8)) // Color tipo Bootstrap
                .foregroundColor(.white)

                // Datos con bordes y sombreado
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.cuenta).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(transaction.debe, specifier: "%.2f")").frame(maxWidth: .infinity, alignment: .trailing)
                        Text("\(transaction.haber, specifier: "%.2f")").frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(Rectangle().stroke(Color.gray.opacity(0.3), lineWidth: 1)) // Bordes sutiles
                    
                }
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1)) // Fondo general sutil
        }
        
    }
}

struct ContentVxiew_Previews: PreviewProvider {
    static var previews: some View {
        ControlTableView()
    }
}
