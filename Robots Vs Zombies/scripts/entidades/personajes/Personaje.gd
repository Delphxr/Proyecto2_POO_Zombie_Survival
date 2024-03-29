extends "res://scripts/entidades/entidad.gd"


# Variables modificables
export var _ataque = 0
export var _vidaMaxima = 0
var vidaActual = 0
export var _rango = 0
export var speed = 0
export var cantidad_ataques = 1
var escudo = false

#Modificación para ítem
var cola_items = []

enum Estado { IDLE, FOLLOW }


var casilla_act = Vector2()
var _state = null

var _pasos = 0 #cantidad de pasos que ha dado en un turno

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()

var siguiendo = false


#señales especiales de items
signal vida_base
signal orbe_curacion
signal teletransport_base
signal teletransport_random
signal VidaSolo
signal kaboom
signal granada



func _ready():
	vidaActual = _vidaMaxima
	_change_state(Estado.IDLE)


func _process(_delta):
	if _state != Estado.FOLLOW:
		return
	var _arrived_to_next_point = _move_to(_target_point_world,speed)
	
	#si logramos avanzar de casilla, quitamos la casilla en la que estamos
	if _arrived_to_next_point:
		_path.remove(0)
		
		if len(_path) == 0 or _pasos == 0: #revisamos si llegamos al lugar, o nos quedamos sin turnos
			position = _target_point_world #esto es para quedarnos centrados en la casilla
			rotation = 0
			_change_state(Estado.IDLE)
			return
		_pasos = _pasos -1
		_target_point_world = _path[0]





func _change_state(new_state):
	if new_state == Estado.FOLLOW:
		
		siguiendo = true
		#llamamos el algoritmo para obtener la ruta, pasamos pocision actual, y posicion deseada
		_path = get_parent().get_node("TileMap").get_astar_path(position, _target_position)
		
		#verificamos si hicimos click en una casilla donde se puede mover
		#o si hicimos click donde ya estamos
		if not _path or len(_path) == 1:
			_change_state(Estado.IDLE)
			return
		
		
		# indice 0 es la celda inicial
		# no queremos volver ahí
		_target_point_world = _path[1]
	_state = new_state
	if new_state == Estado.IDLE:
		casilla_act = position
		siguiendo = false
		print(casilla_act)


func _on_HitBox_area_entered(_area):
	print("Un zombie ha alcanzado a " , self.name)
	
	get_node("sonido").play()
	
	if escudo == false:
		vidaActual -= 1
		print("Vida restante: ", vidaActual)
	
		if vidaActual <= 0:
			self.queue_free()
			print(self.name , " murió")
	
	else:
		escudo = false
		print("Escudo desactivado")
		get_node("escudo").hide()


func _on_Personaje_area_entered(_area):
	pass # Replace with function body.

#Prueba con las señales
func curarse(curacion):
	print ("Función curarse en: " , self.name)
	if vidaActual < _vidaMaxima:
		print(name," se ha curado")
		vidaActual += curacion
		
		if vidaActual > _vidaMaxima:
			vidaActual = _vidaMaxima


func usarItem():
	print("Función usar item con ", cola_items[0])
	if cola_items[0] == "bola":
		emit_signal("vida_base")
		cola_items.remove(0)
	
	elif cola_items[0] == "OrbeCuracion":
		emit_signal("orbe_curacion")
		cola_items.remove(0)
		
	elif cola_items[0] == "TeleBase":
		emit_signal("teletransport_base")
		cola_items.remove(0)
		
	elif cola_items[0] == "TeleRandom":
		emit_signal("teletransport_random")
		cola_items.remove(0)
	
	elif cola_items[0] == "VidaSolo":
		emit_signal("VidaSolo")
		cola_items.remove(0)
		
	elif cola_items[0] == "Kaboom":
		emit_signal("kaboom")
		cola_items.remove(0)
	
	elif cola_items[0] == "Granada":
		emit_signal("granada")
		cola_items.remove(0)
		
	else:
		return 1
		
