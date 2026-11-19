import SwiftUI

struct CarteleraView: View {
    // Esta vista es la dueña de los datos; el Registro los recibe con @Binding.
    @State private var peliculas = Pelicula.ejemplos

    var body: some View {
        NavigationStack {
            List(peliculas) { pelicula in
                FilaPelicula(pelicula: pelicula)
                    .swipeActions(edge: .leading) {
                        if pelicula.esFavorita {
                            Button("Quitar", systemImage: "star.slash") {
                                alternarFavorita(pelicula)
                            }
                            .tint(.gray)
                        } else {
                            Button("Favorito", systemImage: "star") {
                                alternarFavorita(pelicula)
                            }
                            .tint(.yellow)
                        }
                    }
            }
            .navigationTitle("Cartelera")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RegistroView(peliculas: $peliculas)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    // Se busca por id y no por la posición de la fila,
    // porque la posición puede cambiar si la lista cambia.
    private func alternarFavorita(_ pelicula: Pelicula) {
        if let indice = peliculas.firstIndex(where: { $0.id == pelicula.id }) {
            peliculas[indice].esFavorita.toggle()
        }
    }
}

#Preview {
    CarteleraView()
}
