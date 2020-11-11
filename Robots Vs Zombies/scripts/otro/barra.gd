extends Control


export var jugador = "Craigh"
export var frame = 0


func _ready():
	get_node("Sprite").frame = frame
	pass


func _process(_delta):
	get_node("ProgressBar").value = get_parent().get_parent().get_node(jugador).vidaActual
	get_node("ProgressBar").max_value = get_parent().get_parent().get_node(jugador)._vidaMaxima
	get_node("Label").text = str(get_parent().get_parent().get_node(jugador).vidaActual) + "/" + str(get_parent().get_parent().get_node(jugador)._vidaMaxima)
