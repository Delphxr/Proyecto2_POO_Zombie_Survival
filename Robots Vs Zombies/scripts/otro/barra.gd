extends Control


export var jugador = "Craigh"
export var frame = 0


func _ready():
	get_node("Sprite").frame = frame
	pass


func _process(_delta):
	if get_parent().get_parent().get_node_or_null(jugador) != null:
		get_node("ProgressBar").value = get_parent().get_parent().get_node(jugador).vidaActual
		get_node("ProgressBar").max_value = get_parent().get_parent().get_node(jugador)._vidaMaxima
		get_node("Label").text = str(get_parent().get_parent().get_node(jugador).vidaActual) + "/" + str(get_parent().get_parent().get_node(jugador)._vidaMaxima)
	else:
		get_node("ProgressBar").value = 0
		get_node("Label").text = str(get_node("ProgressBar").value) + "/" + str(get_node("ProgressBar").max_value)
		
