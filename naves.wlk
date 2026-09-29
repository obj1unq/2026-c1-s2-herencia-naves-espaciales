class Nave {
	var property velocidad = 0

	method encontrateConEnemigo() {
		self.propulsate()
		self.recibirAmenaza()
	}

	method recibirAmenaza() // abstracto

	method propulsate() {
		self.acelerar(20000)
	}

	method preparateParaViajar() {
		self.acelerar(15000)
	}

	method acelerar(aumento) {
		velocidad = (velocidad + aumento).min(300000)
	}
}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
}

class NaveDeResiduos inherits NaveDeCarga {
	var property sellada = false

	method sellate() {
		sellada = true
	}

	override method recibirAmenaza() {
		velocidad = 0
	}

	override method preparateParaViajar() {
		super()
		self.sellate()
	}
}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method preparateParaViajar() {
		super()
		modo.preparaParaViajar(self)
	}
}

object reposo {
	method invisible() = false
	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	method preparaParaViajar(nave) {
		nave.emitirMensaje(self.mensajeParaViajar())
		nave.modo(ataque)
	}

	method mensajeParaViajar() { return "Saliendo en misión" }
}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	method preparaParaViajar(nave) {
		nave.emitirMensaje(self.mensajeParaViajar())
	}
	
	method mensajeParaViajar() { return "Volviendo a la base" }
}

