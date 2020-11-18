extends "res://scripts/entidades/personajes/Personaje.gd"

var doble_ataque = false

# Hapbot: Personaje cazador
# Habilidad inicial: Escudo
# Habilidades recogibles: -Doble daño
#                         -Doble ataque por turno
func _ready():
	escudo = true
	pass


func hab_doble_ataque():
	print("Cantidad de ataques aumentada")
	cantidad_ataques = 2

func hab_doble_damage():
	print("Daño aumentado")
	_ataque *= 2


func _on_Hapbot_area_entered(area):
	print("Encontrada "  , area.name)
	if area.is_in_group("habs_hapbot"):
		get_node("sound_item").play()
		if area.nombre == "DobleAtaque":
			hab_doble_ataque()
		elif area.nombre == "DobleDamage":
			hab_doble_damage()
