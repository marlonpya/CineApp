import SwiftUI

struct ContentView: View {
    // Se reemplaza la Bienvenida por la Cartelera en lugar de navegar,
    // así la Bienvenida no queda en la pila y no se puede regresar a ella.
    @State private var mostrarCartelera = false

    var body: some View {
        if mostrarCartelera {
            CarteleraView()
        } else {
            BienvenidaView(mostrarCartelera: $mostrarCartelera)
        }
    }
}

#Preview {
    ContentView()
}
