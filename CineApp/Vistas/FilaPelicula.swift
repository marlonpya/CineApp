import SwiftUI

struct FilaPelicula: View {
    // Solo muestra datos, no los cambia: por eso basta con let.
    let pelicula: Pelicula

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "film")
                .font(.title2)

            VStack(alignment: .leading) {
                Text(pelicula.titulo)
                    .bold()
                Text("\(pelicula.duracion) min")
                    .foregroundStyle(.gray)
            }

            Spacer()

            if pelicula.esFavorita {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

#Preview {
    List(Pelicula.ejemplos) { pelicula in
        FilaPelicula(pelicula: pelicula)
    }
}
