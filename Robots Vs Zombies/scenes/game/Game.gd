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
