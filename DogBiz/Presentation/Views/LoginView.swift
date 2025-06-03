import SwiftUI

struct AuthenticationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingGoogleSignInAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "person.circle.fill") // Icono representativo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentColor) // O un color de tu marca

                Text("Bienvenido")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Correo Electrónico")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("ejemplo@dominio.com", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Text("Contraseña")
                        .font(.headline)
                        .foregroundColor(.gray)
                    SecureField("Ingresa tu contraseña", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                Button(action: {
                    // Aquí iría la lógica de autenticación con email y contraseña
                    print("Autenticando con email: \(email) y contraseña: \(password)")
                }) {
                    Text("Iniciar Sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // Color principal del botón
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Separador o texto "o"
                HStack {
                    VStack { Divider() }
                    Text("o")
                        .foregroundColor(.gray)
                    VStack { Divider() }
                }
                .padding(.horizontal)

                Button(action: {
                    // Aquí iría la lógica para iniciar el flujo de autenticación de Google
                    // Esto usualmente implica llamar a un método del SDK de Google Sign-In
                    showingGoogleSignInAlert = true // Para simular la acción en la UI
                    print("Intentando autenticar con Google")
                }) {
                    HStack {
                        Image("google_logo") // Asegúrate de tener una imagen de logo de Google en tus Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Continuar con Google")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                .alert("Autenticación con Google", isPresented: $showingGoogleSignInAlert) {
                    Button("OK") { }
                } message: {
                    Text("Aquí se iniciaría el flujo de autenticación de Google. Necesitas configurar el SDK de Google Sign-In en tu proyecto.")
                }


                Spacer()
                
                // Opcional: Enlace para recuperar contraseña o registrarse
                HStack {
                    Button("¿Olvidaste tu contraseña?") {
                        // Acción para recuperar contraseña
                    }
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Button("Registrarse") {
                        // Acción para navegar a la vista de registro
                    }
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all)) // Fondo de la vista
            .navigationBarHidden(true) // Oculta la barra de navegación predeterminada para un look más limpio
        }
    }
}

// Puedes crear un Assets llamado "google_logo" y arrastrar una imagen del logo de Google allí.
// Si no tienes una imagen, puedes usar un icono de SF Symbols si hay uno adecuado, o simplemente quitar la imagen.

// Para previsualizar en Xcode Canvas
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
