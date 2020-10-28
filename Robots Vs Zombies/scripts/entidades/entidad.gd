extends Area2D

var _velocity = Vector2()
var MASA = 2
const ARRIVE_DISTANCE = 2.0


#   esto nos movemos, dada la posicion que queremos
func _move_to(world_position,speed):
	var desired_velocity = (world_position - position).normalized() * speed #con esto quitamos la aceleracion
	var steering = desired_velocity - _velocity
	_velocity += steering / MASA
	
	#cambiar si el sprite ve a la izquierda o la derecha
	if _velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		
	position += _velocity * get_process_delta_time()
	return position.distance_to(world_position) < ARRIVE_DISTANCE
