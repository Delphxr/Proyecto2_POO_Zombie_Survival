extends "res://scripts/entidades/personajes/Personaje.gd"

func _ready():
	pass


func habDobleVida():
	_vidaMaxima *= 2
	vidaActual = _vidaMaxima
	print("Vida aumentada a " , _vidaMaxima)
	
	
func _on_Firebot_area_entered(area):
	print("Encontrada "  , area.name)
	if area.name == "DobleVida":
		habDobleVida()
