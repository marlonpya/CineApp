import SwiftUI

struct ContentView: View {
    // Se reemplaza el Splash por la Cartelera en lugar de navegar,
    // así el Splash no queda en la pila y no se puede regresar a él.
    @State private var mostrarSplash = true

    var body: some View {
        if mostrarSplash {
            SplashView()
                .task {
                    try? await Task.sleep(for: .seconds(2))
                    mostrarSplash = false
                }
        } else {
            CarteleraView()
        }
    }
}

#Preview {
    ContentView()
}
