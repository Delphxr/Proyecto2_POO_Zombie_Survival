extends "res://scripts/entidades/personajes/Personaje.gd"

func _ready():
	
	_rango = 4
	pass
	

func habDobleRango():
	get_node("sound_item").play()
	#Duplica el rango
	_rango *= 2

func _on_Craigh_area_entered(area):
	if area.is_in_group("items_craigh"):
		habDobleRango()
		print("Rango aumentado a " , _rango)
