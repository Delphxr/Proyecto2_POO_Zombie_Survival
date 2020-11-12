extends TextureButton


var click


func _on_TextureButton_pressed():
	click = get_tree().change_scene("res://scenes/menu/Menu.tscn")
	
