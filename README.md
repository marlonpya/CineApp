# Cine App: simulacro resuelto de la T1

> **Simulacro.** Esta app es el simulacro de la primera evaluación (T1) de *Desarrollo de Aplicaciones Móviles II* (CIBERTEC). Los exámenes reales tienen la misma estructura y rúbrica, con otro tema.
>
> - Enunciado del simulacro: [simulacro/Simulacro_T1_CineApp.pdf](simulacro/Simulacro_T1_CineApp.pdf)
> - Solución explicada paso a paso: [simulacro/Simulacro_T1_CineApp_resuelto.pdf](simulacro/Simulacro_T1_CineApp_resuelto.pdf)
> - Guía para la sustentación oral: [SUSTENTACION.md](SUSTENTACION.md)
>
> Intenta resolverlo primero sin mirar el código.

> **Estado del repositorio.** El proyecto ya está desarrollado: abre `CineApp.xcodeproj` en Xcode 16 o posterior y ejecútalo en un simulador con iOS 17 o superior. El `.xcodeproj` se escribió a mano en Windows (carpetas sincronizadas, formato de Xcode 16) y **todavía no se ha compilado en una Mac**: el primer paso es compilarlo y corregir lo que Xcode reporte. 
>
> Lo que sigue es el enunciado con el que se pidió el desarrollo.

Instrucciones para que **Claude Code** desarrolle la solución de referencia del examen T1 del curso *Desarrollo de Aplicaciones Móviles II* (CIBERTEC). Es el modelo de corrección del docente: el código debe ser simple, claro y usar solo lo visto en clase (Temas 1 al 4).

## Antes de empezar (lo hace el docente)

1. En Xcode: `File > New > Project > iOS > App`.
   - Product Name: `CineApp`
   - Interface: **SwiftUI** · Language: **Swift** · Storage: **None** · sin tests.
   - Minimum Deployments: **iOS 17.0**.
2. Cierra Xcode, abre una terminal en la carpeta del proyecto, copia este archivo como `README.md` y ejecuta `claude`.
3. Pídele: **"Lee el README.md y desarrolla la app completa siguiéndolo al pie de la letra."**

## Restricciones obligatorias

- Solo **SwiftUI** con **Swift**; nada de UIKit, storyboards ni librerías externas.
- Estado con **`@State`** y **`@Binding`**. **Sin ViewModel**: no usar `@Observable`, `ObservableObject`, `@StateObject`, `@EnvironmentObject` ni `@Environment` con objetos propios. La única excepción permitida es `@Environment(\.dismiss)`, que es un valor del sistema y no un objeto propio.
- Navegación con **`NavigationStack`** (no `NavigationView`).
- Solo lo visto en clase: **no usar** `.alert`, `.sheet`, `Picker`, `Toggle`, `Stepper`, `.task` ni `async/await`.
- Sin persistencia: los datos viven en memoria.
- Nombres de tipos, variables y textos de la interfaz **en español**. Comentarios breves que expliquen el *porqué*.
- No modificar la configuración del proyecto (`.xcodeproj`) salvo agregar archivos. Si el proyecto usa carpetas sincronizadas (Xcode 16 o posterior), basta con crear los archivos en la carpeta `CineApp/`.

## Flujo de la app

```
Bienvenida ──(botón Ingresar)──▶ Cartelera ──(botón +)──▶ Registro
                                     ▲                        │
                                     └──── Guardar (dismiss) ─┘
```

Desde la Cartelera **no** se puede regresar a la Bienvenida.

## Modelo

```swift
struct Pelicula: Identifiable {
    let id = UUID()
    var titulo: String
    var duracion: Int        // en minutos
    var esFavorita: Bool = false
}
```

Datos iniciales (`static let ejemplos`):

| Título | Duración | Favorita |
|---|---|---|
| Toy Story | 81 | sí |
| Gladiador | 155 | no |
| Coco | 105 | sí |
| El conjuro | 112 | no |

## Pantalla 1: Bienvenida (Pregunta 01, Maquetado)

- Fondo **rojo** en toda la pantalla (`.ignoresSafeArea()`).
- Ícono SF Symbol **`film.fill`**, blanco, **100 x 100**, centrado horizontal y verticalmente.
- Texto **«Cine App»** debajo del ícono, blanco y en negrita.
- Botón **«Ingresar»** debajo del texto: texto rojo sobre fondo blanco en forma de cápsula.
- Al presionar «Ingresar» se muestra la Cartelera.
- Implementación: `ContentView` tiene `@State private var mostrarCartelera = false` y un `if/else` que muestra `CarteleraView` o `BienvenidaView(mostrarCartelera: $mostrarCartelera)`. `BienvenidaView` recibe el valor con `@Binding` y lo pone en `true` al presionar el botón. Como no se navega, la Bienvenida no queda en la pila y no se puede regresar a ella.

## Pantalla 2: Cartelera (Preguntas 02 y 03, Maquetado y Favoritos)

- `NavigationStack` con título **«Cartelera»** y un botón **+** en la barra (`ToolbarItem` en `.topBarTrailing`) que navega al Registro.
  - El botón es un **`NavigationLink`** con `Image(systemName: "plus")` como etiqueta y `RegistroView(peliculas: $peliculas)` como destino.
- La vista es **dueña de los datos**: `@State private var peliculas = Pelicula.ejemplos`.
- `List` con una fila por película (subvista `FilaPelicula`, que recibe la película con `let`):
  - Ícono SF Symbol `film`.
  - Título en negrita.
  - Duración debajo, en gris: «81 min».
  - Estrella **`star.fill` amarilla** a la derecha solo si `esFavorita`.
- **Swipe de favoritos** con `.swipeActions(edge: .leading)`:
  - Si no es favorita: botón **«Favorito»** con ícono `star`, color amarillo (`.tint(.yellow)`).
  - Si ya es favorita: botón **«Quitar»** con ícono `star.slash`, color gris (`.tint(.gray)`).
  - Al tocarlo, cambia `esFavorita` de esa película. Se busca por `id`, nunca por índice de la fila.

## Pantalla 3: Registro (Preguntas 04 y 05, Validaciones y Navegación)

- Título de navegación **«Nueva película»**.
- Recibe la lista con **`@Binding var peliculas: [Pelicula]`** y usa `@Environment(\.dismiss)` para volver.
- `Form` con:
  - `TextField` **Título** (placeholder «Ingresar título»).
  - `TextField` **Duración** (placeholder «Duración en minutos», `.keyboardType(.numberPad)`), guardado como `String` en un `@State`.
  - Debajo de los campos, el **mensaje de error en rojo**, solo si hay uno: `@State private var mensajeError = ""` y `if !mensajeError.isEmpty { Text(mensajeError).foregroundStyle(.red) }`.
- Botón **«Guardar»** en la barra superior (`ToolbarItem(placement: .confirmationAction)`).
- Al presionar «Guardar», valida **en este orden** y se detiene en el primer error:

| # | Regla | Mensaje de error |
|---|---|---|
| 1 | Título vacío | «Ingrese el título de la película.» |
| 2 | Duración vacía | «Ingrese la duración de la película.» |
| 3 | Título con menos de 2 caracteres | «El título debe tener al menos 2 caracteres.» |
| 4 | Duración no numérica (`Int(texto) == nil`) o fuera de 60 a 240 | «La duración debe ser un número entre 60 y 240 minutos.» |

- Si hay un error, se guarda en `mensajeError` y aparece debajo de los campos.
- Si todo es válido: agrega la película (no favorita) a `peliculas` y llama a `dismiss()` para volver a la Cartelera.
- Separar la validación en una función `validar() -> String?` que devuelva el mensaje de error o `nil`.
- **Recomendado, no exigido al alumno:** quitar los espacios al inicio y al final con `trimmingCharacters(in: .whitespaces)` antes de validar, para que `"  a "` falle en la regla 3 y `" 90 "` sea válida. La solución de referencia lo hace; un alumno que valide solo con `isEmpty` no pierde puntos.

## Estructura de archivos

```
CineApp/
├── CineAppApp.swift          (sin cambios)
├── ContentView.swift         Bienvenida → Cartelera (if/else)
├── Modelo/
│   └── Pelicula.swift        struct + ejemplos
└── Vistas/
    ├── BienvenidaView.swift
    ├── CarteleraView.swift   lista, swipe de favoritos y botón +
    ├── FilaPelicula.swift
    └── RegistroView.swift    formulario, validaciones y mensaje de error
```

Cada vista con su `#Preview`. Para los `@Binding`, usar `.constant(...)`.

## Launch screen (opcional, no se evalúa)

La solución de referencia incluye una launch screen nativa roja (`UILaunchScreen` en `Info.plist`, color `FondoSplash`) para que no se vea blanco antes de la Bienvenida. No es parte del examen.

## Criterios de aceptación (rúbrica del examen)

- [ ] **P01:** la Bienvenida coincide con el prototipo y el botón «Ingresar» lleva a la Cartelera.
- [ ] **P02:** la Cartelera muestra las 4 películas con título, duración y estrella.
- [ ] **P03:** el swipe marca y desmarca favoritos, y la estrella aparece y desaparece.
- [ ] **P04:** las 4 validaciones muestran su mensaje debajo de los campos; los datos válidos agregan la película.
- [ ] **P05:** Bienvenida → Cartelera → Registro → (Guardar) → Cartelera, con `NavigationStack` y `dismiss`.
- [ ] El proyecto compila sin errores ni advertencias en Xcode, con destino iOS 17.

## Al terminar

1. Compila con `xcodebuild -scheme CineApp -destination 'generic/platform=iOS Simulator' build` (no depende del nombre de un simulador concreto) y corrige cualquier error o advertencia.
2. Resume en una tabla qué propiedad usa `@State`, cuál `@Binding` y por qué. Sirve como guía de sustentación.
3. Propón 5 preguntas cortas para la sustentación oral, con su respuesta esperada.
