extends "res://scripts/entidades/personajes/Personaje.gd"

func _ready():
	pass

func habDobleAtaque():
	_ataque *= 2
	print("Ataque de " , self.name, " aumentado a ", _ataque)
	
	

func _on_hapbot_area_entered(area):
	if area.is_in_group("habs_hapbot"):
		if area.nombre == "DobleAtaque":
			habDobleAtaque()
