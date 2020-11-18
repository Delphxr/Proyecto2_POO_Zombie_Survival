extends "res://scripts/entidades/personajes/Personaje.gd"

func _ready():
	cola_items.append("Kaboom")
	_rango = 4
	pass
	

func habDobleRango():
	get_node("sound_item").play()
	#Duplica el rango
	_rango *= 2
	print("Rango aumentado a " , _rango)

func aumentarVision():
	#Aumenta la visión de Craigh
	$Camera2D.zoom.y += 0.5
	$Camera2D.zoom.x += 0.5
	print("Visión aumentada")

func _on_Craigh_area_entered(area):
	if area.is_in_group("items_craigh"):
		if area.nombre == "DobleRango":
			habDobleRango()
		
		elif area.nombre == "AumentoVision":
			aumentarVision()
		

