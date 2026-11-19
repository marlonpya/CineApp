import Foundation

// Struct (tipo valor): al cambiar una propiedad, SwiftUI detecta el cambio
// en el arreglo @State y vuelve a dibujar la lista.
struct Pelicula: Identifiable {
    let id = UUID()
    var titulo: String
    var duracion: Int        // en minutos
    var esFavorita: Bool = false

    // Datos iniciales en memoria: la app no tiene persistencia.
    static let ejemplos: [Pelicula] = [
        Pelicula(titulo: "Toy Story", duracion: 81, esFavorita: true),
        Pelicula(titulo: "Gladiador", duracion: 155),
        Pelicula(titulo: "Coco", duracion: 105, esFavorita: true),
        Pelicula(titulo: "El conjuro", duracion: 112)
    ]
}
