extends TextureButton


var click

func _on_TextureButton_pressed():
	click = get_tree().change_scene("res://scenes/game/Game.tscn")
	pass # Replace with function body.
