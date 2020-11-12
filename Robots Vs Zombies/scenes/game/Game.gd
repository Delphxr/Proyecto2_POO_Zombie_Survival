extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turno = 0
var actual = 0
export var max_turnos = 2

# Called when the node enters the scene tree for the first time.


# ----------------------------------------------------------


const enemies = [
	preload("res://scenes/entidades/zombies/EnemyA/EnemigoA.tscn"),
	preload("res://scenes/entidades/zombies/EnemyB/enemigoB.tscn"),
	preload("res://scenes/entidades/zombies/EnemyC/EnemigoC.tscn")
]

var jugadores = []


#coordenadas de las tiles caminables
onready var caminos = get_node("TileMap").get_used_cells_by_id(5)


#coordenadas de los puntos de generacion
onready var spawn_points = get_node("TileMap").get_used_cells_by_id(8)
var zonas = []


func _ready():
	add_user_signal("nuevo_click")
	add_user_signal("fin_turno")
	turnos()
	spawn()
	pass

func _process(_delta):
	#Si la base desaparece, se pierde el juego
	
	if get_node_or_null("base") == null:
		get_node("CanvasLayer/gameover").show()
		get_node("EfectoGameOver").show()
		get_node("generalcam").current = true
		get_node("Musica").stop()
	if get_node_or_null("Craigh") == null and get_node_or_null("Firebot") == null and get_node_or_null("hapbot") == null:
		get_node("CanvasLayer/gameover").show()
		get_node("EfectoGameOver").show()
		get_node("generalcam").current = true
		get_node("Musica").stop()


func mover_zombies():
	yield(create_timer(1), "timeout")
	var zombies_vivos = get_tree().get_nodes_in_group("zombies")
	for vivo in zombies_vivos:
		vivo.moverse()

func get_spawn(tiles):
	zonas = []
	for point in tiles:
		var point_temp = Vector2()
		point_temp.x = get_node("TileMap").map_to_world(point).x +16
		point_temp.y = get_node("TileMap").map_to_world(point).y +16
		
		zonas.append(point_temp)

func spawn():
	get_spawn(spawn_points)
	randomize()
	
	for espacio in zonas:
		var enemy = choose(enemies).instance()
		enemy.position = espacio
		add_child(enemy)
		enemy.add_to_group("zombies")
		print ("enemigo generado: " , enemy.name)
		
	pass

func nuevo_spawn(tiles):
	randomize()
	var nueva = choose(tiles)
	get_node("TileMap").set_cell(nueva.x,nueva.y,8)
	spawn_points = get_node("TileMap").get_used_cells_by_id(8)
	print ("Creado nuevo punto de generacion")


func create_timer(wait_time):
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()
	return timer
	pass

func choose(choises):
	randomize()
	var rand_index = randi() % choises.size()
	return choises[rand_index]
	pass


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		emit_signal("nuevo_click")
		return

#revisamos que los jugadores aun existan
func check_jugadores():
	jugadores = [
		get_node_or_null("Craigh"),
		get_node_or_null("Firebot"),
		get_node_or_null("hapbot")
	]

#funcion para los turnos
func turnos():
	while true:
		yield(jugar(turno),"completed")
		turno = (turno+1)%4
	

# de aqui se manejan los turnos
func moverse(turn):

	#mover zombies
	if turn == 3:
		get_node("generalcam").current = true
		get_node("CanvasLayer/mensaje").show()
		mover_zombies()
		
		yield(self,"nuevo_click")
		nuevo_spawn(caminos)
		spawn()
		actual = 0
	
		
	#mover jugadores
	else:
		
		yield(self,"nuevo_click")
		var global_mouse_pos = get_global_mouse_position()
		check_jugadores()
		
		if jugadores[turn] != null:
			
		
			jugadores[turn]._pasos = jugadores[turn]._rango
			jugadores[turn]._target_position = global_mouse_pos
			jugadores[turn]._change_state(jugadores[turn].Estado.FOLLOW)
			jugadores[turn].get_node("Camera2D").current = true
			yield(create_timer(3), "timeout")
			
			actual = turn +1 
	
	check_jugadores()
	while true:
		actual = (actual)%3
		if jugadores[actual] != null:
			jugadores[actual].get_node("Camera2D").current = true
			emit_signal("fin_turno")
			return false
		actual+=1

# de aqui se manejan los turnos
func atacar(turn):
	
	#saltar zombies
	if turn == 3:
		emit_signal("fin_turno")
		return
	
	#ataque de jugadores
	else:
		yield(self,"nuevo_click")
		var global_mouse_pos = get_global_mouse_position()
		
		check_jugadores()
		
		if jugadores[turn] != null:
			jugadores[turn]._pasos = get_node("Craigh")._rango
			jugadores[turn]._target_position = global_mouse_pos
			jugadores[turn]._change_state(get_node("Craigh").Estado.FOLLOW)
			jugadores[turn].get_node("Camera2D").current = true
			yield(create_timer(3), "timeout")
			
			var actual = turn
			while true:
				actual = (actual+1)%3
				if jugadores[actual] != null:
					jugadores[actual].get_node("Camera2D").current = true
					emit_signal("fin_turno")
					return
		


func jugar(turn):
	print(turn)
	moverse(turn)
	yield(self,"fin_turno")
	#atacar(turn)
	#yield(self,"fin_turno")
	

