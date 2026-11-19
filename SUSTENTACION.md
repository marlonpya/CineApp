# Guía de sustentación

## Estado de cada vista

| Vista | Propiedad | Tipo | Por qué |
|---|---|---|---|
| `ContentView` | `mostrarCartelera` | `@State` | Decide qué pantalla se ve. Al pasar a `true` se reemplaza la Bienvenida por la Cartelera, sin navegar, así la Bienvenida no queda en la pila. |
| `BienvenidaView` | `mostrarCartelera` | `@Binding` | No es dueña del valor; lo recibe de `ContentView` para cambiarlo al presionar «Ingresar». |
| `CarteleraView` | `peliculas` | `@State` | La Cartelera es la dueña de la lista: la crea y la modifica (favoritos). |
| `RegistroView` | `peliculas` | `@Binding` | No es dueña de la lista; recibe un enlace a la de la Cartelera para agregarle una película. Al volver, la Cartelera ya ve el cambio. |
| `RegistroView` | `titulo`, `duracion` | `@State` | Texto temporal del formulario; solo le interesa a esta vista. `duracion` es `String` porque el `TextField` trabaja con texto. |
| `RegistroView` | `mensajeError` | `@State` | Texto del error de validación. Vacío significa "sin error"; si tiene texto, se muestra en rojo debajo de los campos. |
| `RegistroView` | `dismiss` | `@Environment(\.dismiss)` | Acción del sistema para volver a la pantalla anterior; no es un objeto propio. |
| `FilaPelicula` | `pelicula` | `let` | Solo muestra datos, no los modifica. |

## Preguntas para la sustentación oral

1. **¿Por qué la lista usa `@State` en la Cartelera y `@Binding` en el Registro?**
   Porque la Cartelera es la dueña de los datos. El Registro solo necesita modificarlos, así que recibe un enlace (`$peliculas`) a la misma lista en vez de una copia.

2. **¿Por qué no se puede volver a la Bienvenida desde la Cartelera?**
   Porque no se navega hacia la Cartelera: el botón «Ingresar» cambia `mostrarCartelera` a `true` y el `if/else` de `ContentView` muestra otra vista en su lugar. La Bienvenida nunca entra en la pila del `NavigationStack`.

3. **¿Por qué el swipe busca la película por `id` y no por la posición de la fila?**
   Porque la posición puede cambiar si se agregan, quitan u ordenan películas. El `id` (UUID) identifica siempre a la misma película.

4. **¿Cómo aparece y desaparece el mensaje de error?**
   `mensajeError` es un `@State`. Al presionar «Guardar», `validar()` devuelve el mensaje de la primera regla que falla y se guarda ahí; como cambió un `@State`, SwiftUI vuelve a dibujar la vista y el `if !mensajeError.isEmpty` muestra el `Text` en rojo.

5. **¿Cómo regresa el Registro a la Cartelera después de guardar?**
   Llama a `dismiss()`, que obtiene de `@Environment(\.dismiss)`. Esto quita el Registro de la pila del `NavigationStack` y vuelve a la Cartelera, que ya muestra la nueva película gracias al `@Binding`.
