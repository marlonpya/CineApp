import SwiftUI

struct RegistroView: View {
    // @Binding: la lista pertenece a la Cartelera; aquí solo se le agrega una película.
    @Binding var peliculas: [Pelicula]
    @Environment(\.dismiss) private var dismiss

    @State private var titulo = ""
    // String porque el TextField trabaja con texto; se convierte a Int al validar.
    @State private var duracion = ""
    // Vacío cuando no hay error; si tiene texto, se muestra debajo de los campos.
    @State private var mensajeError = ""

    // Se ignoran los espacios al inicio y al final antes de validar y guardar.
    private var tituloLimpio: String {
        titulo.trimmingCharacters(in: .whitespaces)
    }

    private var duracionLimpia: String {
        duracion.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Form {
            TextField("Ingresar título", text: $titulo)
            TextField("Duración en minutos", text: $duracion)
                .keyboardType(.numberPad)

            if !mensajeError.isEmpty {
                Text(mensajeError)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("Nueva película")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar", action: guardar)
            }
        }
    }

    // Devuelve el mensaje del primer error encontrado, o nil si todo es válido.
    // El orden de las reglas es el que pide el enunciado.
    private func validar() -> String? {
        if tituloLimpio.isEmpty {
            return "Ingrese el título de la película."
        }
        if duracionLimpia.isEmpty {
            return "Ingrese la duración de la película."
        }
        if tituloLimpio.count < 2 {
            return "El título debe tener al menos 2 caracteres."
        }
        guard let minutos = Int(duracionLimpia), (60...240).contains(minutos) else {
            return "La duración debe ser un número entre 60 y 240 minutos."
        }
        return nil
    }

    private func guardar() {
        if let error = validar() {
            mensajeError = error
            return
        }

        // validar() ya comprobó que la duración es un número válido.
        guard let minutos = Int(duracionLimpia) else { return }
        peliculas.append(Pelicula(titulo: tituloLimpio, duracion: minutos))
        dismiss()
    }
}

#Preview {
    NavigationStack {
        RegistroView(peliculas: .constant(Pelicula.ejemplos))
    }
}
