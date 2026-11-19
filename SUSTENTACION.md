# Guía de sustentación

## Estado de cada vista

| Vista | Propiedad | Tipo | Por qué |
|---|---|---|---|
| `ContentView` | `mostrarSplash` | `@State` | Decide qué pantalla se ve. Al pasar a `false` se reemplaza el Splash por la Cartelera, sin navegar, así el Splash no queda en la pila. |
| `CarteleraView` | `peliculas` | `@State` | La Cartelera es la dueña de la lista: la crea y la modifica (favoritos). |
| `RegistroView` | `peliculas` | `@Binding` | No es dueña de la lista; recibe una referencia a la de la Cartelera para agregarle una película. Al volver, la Cartelera ya ve el cambio. |
| `RegistroView` | `titulo`, `duracion` | `@State` | Texto temporal del formulario; solo le interesa a esta vista. `duracion` es `String` porque el `TextField` trabaja con texto. |
| `RegistroView` | `mensajeError`, `mostrarAlerta` | `@State` | Controlan la alerta de validación. |
| `RegistroView` | `dismiss` | `@Environment(\.dismiss)` | Acción del sistema para volver a la pantalla anterior; no es un objeto propio. |
| `FilaPelicula` | `pelicula` | `let` | Solo muestra datos, no los modifica. |

## Preguntas para la sustentación oral

1. **¿Por qué la lista usa `@State` en la Cartelera y `@Binding` en el Registro?**
   Porque la Cartelera es la dueña de los datos. El Registro solo necesita modificarlos, así que recibe un enlace (`$peliculas`) a la misma lista en vez de una copia.

2. **¿Por qué no se puede volver al Splash desde la Cartelera?**
   Porque no se navega hacia la Cartelera: `ContentView` cambia `mostrarSplash` a `false` y muestra otra vista en su lugar. El Splash nunca entra en la pila del `NavigationStack`.

3. **¿Por qué el swipe busca la película por `id` y no por la posición de la fila?**
   Porque la posición puede cambiar si se agregan, quitan u ordenan películas. El `id` (UUID) identifica siempre a la misma película.

4. **¿Qué pasa si escribo `"  a "` como título y `90` como duración?**
   Se recortan los espacios y queda `"a"`: pasa la regla 1 (no está vacío) y la regla 2 (hay duración), pero falla la regla 3 y la alerta dice «El título debe tener al menos 2 caracteres.».

5. **¿Cómo regresa el Registro a la Cartelera después de guardar?**
   Llama a `dismiss()`, que obtiene de `@Environment(\.dismiss)`. Esto quita el Registro de la pila del `NavigationStack` y vuelve a la Cartelera, que ya muestra la nueva película gracias al `@Binding`.
