extends "res://scripts/entidades/personajes/Personaje.gd"


#Firebot: Personaje tanque
#Habilidades:
#	Inicial: Retorna daño cuando un zombie le hace daño
#	Doble de vida

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
