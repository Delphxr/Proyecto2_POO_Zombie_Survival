extends TileMap



# tamaño del mapa, se mide en cantidad de tiles en ancho y alto, mejor modificar en gui
export(Vector2) var map_size = Vector2.ONE * 16

# inicio y fin del camino, se definen al final del codigo

var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

# creamos un nodo AStar, para el pathfinding
onready var astar_node = AStar.new()

# get_used_cells_by_id es un metodo de los tilemap
onready var obstacles = get_used_cells_by_id(6) + get_used_cells_by_id(7)
onready var _half_cell_size = cell_size / 2 #con esto hacemos que se mueva en el medio de los tiles, y no en los bordes

func _ready():
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)



# Hacemos loop por todas las celdas, las añadimos al AStar
# excepto las que son un obtaculo
func astar_add_walkable_cells(obstacle_list = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacle_list:
				continue

			points_array.append(point)
			
			# The AStar class nececita indices para las celdas
			# usamos esta funcion para tener un indice unico para cada celda
			var point_index = calculate_point_index(point)
			
			# AStar sirve para 3d y 2d, por eso usa Vector3
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# una vez tenemos todos los puntos en el Astar, los conectamos
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# Para cada tile del mapa, revisamos arriba, abajo
		# derecha e izquiera de donde estamos. vemos si esta y el mapa y si no es un obstaculo
		# We connect the current point with it.
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.DOWN,
			point + Vector2.UP,
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)
			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			
			
			# Con el 3r argumento decimos que queremos ir solo de A -> B, y no de B -> A
			astar_node.connect_points(point_index, point_relative_index, false)



func calculate_point_index(point):
	return point.x + map_size.x * point.y



# revisamos si estamos fuera del limite del mapa
func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func get_astar_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	
	# con este metodo obtenemos un array de puntos para movernos
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)



# colocamos el inicio y el fin del camino
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_end_position = value
	if path_start_position != value:
		_recalculate_path()
