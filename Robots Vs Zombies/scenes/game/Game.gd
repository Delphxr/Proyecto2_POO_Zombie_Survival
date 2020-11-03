extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turno = 1
export var max_turnos = 2

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		turno = 1
		print("turno")
	elif event.is_action_pressed("ui_down"):
		turno = 0
		print("no turno")
	
	return turno

# ----------------------------------------------------------


const enemies = [
	preload("res://scenes/entidades/zombies/EnemyA/EnemigoA.tscn")
]

func _ready():
	spawn()
	pass

func choose(choises):
	randomize()
	var rand_index = randi() % choises.size()
	return choises[rand_index]
	pass
	
func create_timer(tiempo):
	var timer = Timer.new()
	timer.set_wait_time(tiempo)
	timer.set_one_shot(true)
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()
	return timer
	pass
	
func spawn():
	while true:
		randomize()
		
		var enemy = choose(enemies).instance()
		enemy.position = get_node("Craigh").global_position
		add_child(enemy)
		yield(create_timer(rand_range(5, 10)), "timeout")
	pass
