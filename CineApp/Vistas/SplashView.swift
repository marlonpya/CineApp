import SwiftUI

struct SplashView: View {
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
            }
        }
    }
}

#Preview {
    SplashView()
}
