extends Area2D

export var nombre_item = ""
signal recogido

func _on_Area2D_area_entered(area):
	
	print("Encontrada por " , area.name)
	
	if area.is_in_group("Personajes"):
		emit_signal("recogido",nombre_item)
		self.queue_free()
