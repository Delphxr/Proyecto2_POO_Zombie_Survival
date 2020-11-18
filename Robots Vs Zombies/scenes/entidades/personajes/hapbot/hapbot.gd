extends "res://scripts/entidades/personajes/Personaje.gd"

var doble_ataque = false

func _ready():
	pass


func hay_doble_danno():
	get_node("sound_item").play()
	cantidad_ataques = 2



func _on_Hapbot_area_entered(area):
	print("Encontrada "  , area.name)
	if area.is_in_group("habs_hapbot"):
		hay_doble_danno()
