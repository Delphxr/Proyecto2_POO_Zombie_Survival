extends "res://scripts/entidades/entidad.gd"



# Variables modificables
export var _ataque = 0
export var _vida = 0
export var _rango = 1
export var speed = 50
export var puntos = 0


var damage = 1
signal muerto

var ruido = false
var origen_ruido = Vector2()

enum Estado { IDLE, FOLLOW }

var existo = true
var casilla_act = Vector2()
var _state = null

var _pasos = 0 #cantidad de pasos que ha dado en un turno

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()

var atacando = false

func _ready():
	add_user_signal("fin_animacion")
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

func create_timer(wait_time):
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()
	return timer
	pass


#de aqui manejamos movimiento de los zombies


func moverse():
	_pasos = _rango
	#yield(create_timer(4), "timeout")
	
	if get_parent().get_node_or_null("Craigh") != null:
		if  overlaps_area(get_parent().get_node("Craigh")):
			print("detectado Craigh")
			_target_position = get_parent().get_node("Craigh").global_position
			
			_change_state(Estado.FOLLOW)
			return
	if get_parent().get_node_or_null("Firebot") != null:
		if  overlaps_area(get_parent().get_node("Firebot")):
			print("detectado Firebot")
			_target_position = get_parent().get_node("Firebot").global_position
			
			_change_state(Estado.FOLLOW)
			return
	if get_parent().get_node_or_null("hapbot") != null:	
		if  overlaps_area(get_parent().get_node("hapbot")):
			print("detectado Hapbot")
			_target_position = get_parent().get_node("hapbot").global_position
			
			_change_state(Estado.FOLLOW)
			return
	
	if ruido == true:
		if _state != Estado.FOLLOW:
			print ("siguiendo ruido")
			_target_position = origen_ruido
			_change_state(Estado.FOLLOW)
			ruido = false
			return
	
	_target_position = Vector2(1104,752)
	_change_state(Estado.FOLLOW)
	return


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
		

func quitarVida():
	get_node("animacion").play("daño")
	yield(self,"fin_animacion")
	_vida -= damage
	
	if _vida <= 0:
		print(self.name, " murió")
		emit_signal("muerto",global_position,puntos)
		self.queue_free()


func _on_Area2D_area_entered(area):
	if(area.get_parent().name == "Firebot"):
		print("Alcanzado por Firebot")
		quitarVida()
	
	elif area.get_parent().name == "base":
		print(self.name , " llegó a la base.")
		self.queue_free()
		
	elif area.name == "AreaGranada":
		print("Alcanzado por granada")
		quitarVida()


func _on_click_area_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed && atacando == true):
		quitarVida()
	


func _on_animacion_animation_finished(_anim_name):
	emit_signal("fin_animacion")
