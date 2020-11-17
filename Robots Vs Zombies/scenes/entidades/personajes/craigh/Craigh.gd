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
		
	#Recoge un item
	if area.is_in_group("Item"):
		itemEquipado[0] = area.nombreItem
		itemEquipado[1] = area.tipo
		print(itemEquipado[0], " obtenid@, tipo: ", itemEquipado[1])
