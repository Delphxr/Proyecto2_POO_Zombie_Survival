extends "res://scenes/Items/Item.gd"


signal curarBase

func _ready():
	print("Nombre Item:" , self.name)
	pass
	

func efectoItem():
	
	print("Función efecto Item")
	emit_signal("curarBase")
