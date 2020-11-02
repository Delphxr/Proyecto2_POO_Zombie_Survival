extends "res://scripts/entidades/entidad.gd"



# Variables modificables
export var _ataque = 0
export var _vida = 0
export var _rango = 0
export var speed = 200

enum Estado { IDLE, FOLLOW }


var casilla_act = Vector2()
var _state = null

var _pasos = 0 #cantidad de pasos que ha dado en un turno

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()



func _ready():
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


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		_pasos = _rango #reiniciamos la cantidad de pasos
		
	
		_target_position = get_parent().get_node("Craigh").global_position
		
		_change_state(Estado.FOLLOW)




func _change_state(new_state):
	if new_state == Estado.FOLLOW:
		
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
		print(casilla_act)
