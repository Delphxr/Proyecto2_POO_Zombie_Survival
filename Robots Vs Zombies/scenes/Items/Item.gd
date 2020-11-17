extends Area2D
class_name Items

export var nombreItem = ""
export var tipo = ""

func _ready():
	pass

func _on_Item_area_entered(area):
	
	print(self.nombreItem, " encontrado por: " , area.name)
	if area.is_in_group("Personajes"):
		print(self.nombreItem, " encontrado por: " , area.name)
		queue_free()
