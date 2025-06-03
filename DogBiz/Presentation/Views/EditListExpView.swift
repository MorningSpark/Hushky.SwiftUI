import SwiftUI

struct EditableListView: View {
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    @State private var selectedItemIndex: Int?
    @State private var editedText = ""

    var body: some View {
        NavigationStack {
            List(items.indices, id: \.self) { index in
                Button(action: {
                    selectedItemIndex = index
                    editedText = items[index]
                    showEditAlert()
                }) {
                    Text(items[index])
                }
            }
            .navigationTitle("Lista Editable")
        }
    }

    // **Función para mostrar la alerta con UITextField**
    func showEditAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        let alert = UIAlertController(title: "Editar Item", message: "Ingrese el nuevo valor", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = editedText
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            if let newText = alert.textFields?.first?.text, let index = selectedItemIndex {
                items[index] = newText
            }
        })

        rootViewController.present(alert, animated: true)
    }
}

// **Previews**
struct EditableListView_Previews: PreviewProvider {
    static var previews: some View {
        EditableListView()
    }
}
