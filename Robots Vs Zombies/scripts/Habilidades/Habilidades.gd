extends Area2D

export var nombre = ""
export var personaje = ""

func _ready():
	pass


func _on_Area2D_area_entered(area):
	
	print("Encontrada por " , area.name)
	
	if area.name == personaje:
		self.queue_free()
