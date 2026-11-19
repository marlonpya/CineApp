import XCTest

// Recorre la app como lo haría un alumno y guarda una captura de cada pantalla
// y de cada caso de validación. Las capturas se usan en el README del simulacro.
final class CapturasUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testCapturas() {
        // Bienvenida
        XCTAssertTrue(app.buttons["Ingresar"].waitForExistence(timeout: 10))
        capturar("01-bienvenida")
        app.buttons["Ingresar"].tap()

        // Cartelera
        let cartelera = app.navigationBars["Cartelera"]
        XCTAssertTrue(cartelera.waitForExistence(timeout: 5))
        capturar("02-cartelera")

        // Swipe en una película que no es favorita
        deslizar(fila("Gladiador"))
        XCTAssertTrue(app.buttons["Favorito"].waitForExistence(timeout: 5))
        capturar("03-swipe-favorito")
        app.buttons["Favorito"].tap()
        esperar(1)
        capturar("04-gladiador-favorito")

        // Swipe en una película que ya es favorita
        deslizar(fila("Toy Story"))
        XCTAssertTrue(app.buttons["Quitar"].waitForExistence(timeout: 5))
        capturar("05-swipe-quitar")
        app.buttons["Quitar"].tap()
        esperar(1)

        // Registro vacío
        cartelera.buttons.firstMatch.tap()
        let titulo = app.textFields["Ingresar título"]
        let duracion = app.textFields["Duración en minutos"]
        XCTAssertTrue(titulo.waitForExistence(timeout: 5))
        capturar("06-registro")

        // Casos de validación, en el orden del enunciado
        probar(titulo: "", duracion: "120", en: titulo, duracion,
               mensaje: "Ingrese el título de la película.", captura: "07-error-titulo-vacio")
        probar(titulo: "Coco", duracion: "", en: titulo, duracion,
               mensaje: "Ingrese la duración de la película.", captura: "08-error-duracion-vacia")
        probar(titulo: "A", duracion: "120", en: titulo, duracion,
               mensaje: "El título debe tener al menos 2 caracteres.", captura: "09-error-titulo-corto")
        probar(titulo: "Up", duracion: "45", en: titulo, duracion,
               mensaje: "La duración debe ser un número entre 60 y 240 minutos.", captura: "10-error-duracion-rango")

        // Datos válidos: se agrega y vuelve a la Cartelera
        escribir("Up", en: titulo)
        escribir("96", en: duracion)
        capturar("11-datos-validos")
        app.buttons["Guardar"].tap()
        XCTAssertTrue(cartelera.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Up"].waitForExistence(timeout: 5))
        esperar(1)
        capturar("12-pelicula-agregada")
    }

    // MARK: - Ayudas

    private func probar(titulo: String, duracion: String,
                        en campoTitulo: XCUIElement, _ campoDuracion: XCUIElement,
                        mensaje: String, captura: String) {
        escribir(titulo, en: campoTitulo)
        escribir(duracion, en: campoDuracion)
        app.buttons["Guardar"].tap()
        XCTAssertTrue(app.staticTexts[mensaje].waitForExistence(timeout: 5), mensaje)
        capturar(captura)
    }

    private func fila(_ texto: String) -> XCUIElement {
        app.cells.containing(.staticText, identifier: texto).firstMatch
    }

    // Arrastre corto hacia la derecha: muestra el botón sin ejecutarlo.
    private func deslizar(_ celda: XCUIElement) {
        let inicio = celda.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        let fin = celda.coordinate(withNormalizedOffset: CGVector(dx: 0.45, dy: 0.5))
        inicio.press(forDuration: 0.05, thenDragTo: fin)
    }

    // Toca el final del campo, borra lo que tenga y escribe el texto nuevo.
    private func escribir(_ texto: String, en campo: XCUIElement) {
        campo.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        if let actual = campo.value as? String, !actual.isEmpty, actual != campo.placeholderValue {
            campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: actual.count))
        }
        if !texto.isEmpty {
            campo.typeText(texto)
        }
    }

    private func esperar(_ segundos: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(segundos))
    }

    private func capturar(_ nombre: String) {
        let adjunto = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        adjunto.name = nombre
        adjunto.lifetime = .keepAlways
        add(adjunto)
    }
}
