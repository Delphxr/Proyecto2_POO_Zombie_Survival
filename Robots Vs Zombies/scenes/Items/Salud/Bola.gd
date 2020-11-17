extends "res://scenes/Items/Item.gd"

signal curarBase

func _ready():
	self.name = nombreItem
	print("Nombre Item:" , self.name)
	pass
	

func efectoItem():
	
	print("Función efecto Item")
	emit_signal("curarBase")
