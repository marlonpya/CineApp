import SwiftUI

struct BienvenidaView: View {
    // @Binding: el valor pertenece a ContentView; al cambiarlo aquí,
    // ContentView reemplaza esta pantalla por la Cartelera.
    @Binding var mostrarCartelera: Bool

    var body: some View {
        ZStack {
            // El fondo ignora el área segura para cubrir toda la pantalla.
            Color.red
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "film.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)

                Text("Cine App")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                Button("Ingresar") {
                    mostrarCartelera = true
                }
                .font(.headline)
                .foregroundStyle(.red)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(.white)
                .clipShape(Capsule())
                .padding(.top, 24)
            }
        }
    }
}

#Preview {
    BienvenidaView(mostrarCartelera: .constant(false))
}
