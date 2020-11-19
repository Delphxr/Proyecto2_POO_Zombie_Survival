extends TextureButton

export var direccion = ""
var click

func _on_TextureButton_pressed():
	click = get_tree().change_scene(direccion)
	pass # Replace with function body.
