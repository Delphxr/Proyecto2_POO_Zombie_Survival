extends "res://scripts/entidades/personajes/Personaje.gd"


func aumentar_vida():
	
	print("vida base aumentada")
	if vidaActual < _vidaMaxima:
		vidaActual += 3
		if vidaActual > _vidaMaxima:
			vidaActual = _vidaMaxima
