extends "res://scripts/entidades/personajes/Personaje.gd"

func _ready():
	
	_rango = 4
	pass
	

func habDobleRango():
	#Duplica el rango
	_rango *= 2

func _on_Craigh_area_entered(area):
	if area.name == "DobleRango":
		habDobleRango()
		print("Rango aumentado a " , _rango)
