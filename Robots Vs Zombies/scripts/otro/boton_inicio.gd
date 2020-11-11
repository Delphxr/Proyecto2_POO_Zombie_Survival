extends TextureButton

var but

func _ready():
	pass

func _on_TextureButton_pressed():
	but = get_tree().change_scene("res://scenes/game/Game.tscn")
	
