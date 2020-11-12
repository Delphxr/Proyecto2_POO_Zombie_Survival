extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turno = 1
export var max_turnos = 2

# Called when the node enters the scene tree for the first time.


# ----------------------------------------------------------


const enemies = [
	preload("res://scenes/entidades/zombies/EnemyA/EnemigoA.tscn"),
	preload("res://scenes/entidades/zombies/EnemyB/enemigoB.tscn"),
	preload("res://scenes/entidades/zombies/EnemyC/EnemigoC.tscn")
]

#coordenadas de las tiles caminables
onready var caminos = get_node("TileMap").get_used_cells_by_id(5)


#coordenadas de los puntos de generacion
onready var spawn_points = get_node("TileMap").get_used_cells_by_id(8)
var zonas = []

func get_spawn(tiles):
	zonas = []
	for point in tiles:
		var point_temp = Vector2()
		point_temp.x = get_node("TileMap").map_to_world(point).x +16
		point_temp.y = get_node("TileMap").map_to_world(point).y +16
		
		zonas.append(point_temp)

func _ready():
	spawn()
	pass

func choose(choises):
	randomize()
	var rand_index = randi() % choises.size()
	return choises[rand_index]
	pass
	
	
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



func _unhandled_input(event):
	if event.is_action_pressed("click"):
		
		var global_mouse_pos = get_global_mouse_position()
		
		
			
		if turno == 1:
			if get_node_or_null("Craigh") != null:
				get_node("Craigh")._pasos = get_node("Craigh")._rango
				get_node("Craigh")._target_position = global_mouse_pos
				get_node("Craigh")._change_state(get_node("Craigh").Estado.FOLLOW)
				get_node("Craigh/Camera2D").current = true
				yield(create_timer(3), "timeout")
			
			if get_node_or_null("Firebot") != null:
				get_node("Firebot/Camera2D").current = true
				turno = 2
				
			elif get_node_or_null("hapbot") != null:
				get_node("hapbot/Camera2D").current = true
				turno = 3
			#Pruebas
			else:
				get_node("generalcam").current = true
				turno = 4
				get_node("CanvasLayer/mensaje").show()
				mover_zombies()
				
			return
		elif turno == 2:
			if get_node_or_null("Firebot") != null:
				get_node("Firebot")._pasos = get_node("Firebot")._rango
				get_node("Firebot")._target_position = global_mouse_pos
				get_node("Firebot")._change_state(get_node("Firebot").Estado.FOLLOW)
				get_node("Firebot/Camera2D").current = true
				yield(create_timer(3), "timeout")
			
			if get_node_or_null("hapbot") != null:
				get_node("hapbot/Camera2D").current = true
				turno = 3
			
			#elif get_node_or_null("Craigh") != null:
			#	get_node("Craigh/Camera2D").current = true
			#	turno = 1
			else:
				get_node("generalcam").current = true
				turno = 4
				get_node("CanvasLayer/mensaje").show()
				mover_zombies()
			return
			
		elif turno == 3:
			if get_node_or_null("hapbot") != null:
				get_node("hapbot")._pasos = get_node("hapbot")._rango
				get_node("hapbot")._target_position = global_mouse_pos
				get_node("hapbot")._change_state(get_node("hapbot").Estado.FOLLOW)
				get_node("hapbot/Camera2D").current = true
				yield(create_timer(3), "timeout")
				get_node("generalcam").current = true
				turno = 4
				mover_zombies()
				get_node("CanvasLayer/mensaje").show()
			return
		
		#Prueba:
		elif turno == 4:
			get_node("generalcam").current = true
			
			nuevo_spawn(caminos)
			spawn()
			
			#yield(create_timer(5), "timeout")
			
			if get_node_or_null("Craigh") != null:
				get_node("Craigh/Camera2D").current = true
				turno = 1
			elif get_node_or_null("Firebot") != null:
				get_node("Firebot/Camera2D").current = true
				turno = 2
			elif get_node_or_null("hapbot") != null:
				get_node("hapbot/Camera2D").current = true
				turno = 3
		
		get_node("CanvasLayer/mensaje").hide()
		return


func _process(_delta):
	#Si la base desaparece, se pierde el juego
	
	if get_node_or_null("base") == null:
		print("GameOver")
		get_node("CanvasLayer/gameover").show()
		get_node("EfectoGameOver").show()
		get_node("Musica").stop()
	if get_node_or_null("Craigh") == null and get_node_or_null("Firebot") == null and get_node_or_null("hapbot") == null:
		print("GameOver")
		get_node("CanvasLayer/gameover").show()
		get_node("EfectoGameOver").show()
		get_node("Musica").stop()


func mover_zombies():
	yield(create_timer(1), "timeout")
	var zombies_vivos = get_tree().get_nodes_in_group("zombies")
	for vivo in zombies_vivos:
		vivo.moverse()

