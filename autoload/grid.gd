extends Node2D

@export var show_debug: bool = false

@export var tightness: int = 6 # higher == more planets
@export var y_margin: int = 50

@export var left_home:Vector2
@export var right_home:Vector2
@export var origin:Vector2
@export var cell_size:int
@export var x_slot_count:int
@export var y_slot_count:int

var grid: Dictionary = {}

func generateGrid():
	var display_size: Vector2 = get_viewport_rect().size
	
	cell_size = int(display_size.x/tightness)
	
	x_slot_count = floor(display_size.x / cell_size) - 2
	y_slot_count = floor((display_size.y - y_margin*2) / cell_size)
	
	origin = Vector2(cell_size,y_margin)
	
	left_home = Vector2(cell_size/2.0,display_size.y/2.0)
	right_home = Vector2(display_size.x - cell_size/2.0,display_size.y/2.0)
	
	for x in x_slot_count:
		for y in y_slot_count:
			grid[Vector2(x,y)] = null
			
			# debug grid
			if show_debug:
				var rect = ReferenceRect.new()
				rect.position = gridToWorld(Vector2(x,y))
				rect.size = Vector2(cell_size, cell_size)
				rect.editor_only = false
				add_child(rect)
				var label = Label.new()
				label.position = gridToWorld(Vector2(x,y))
				label.text = str(Vector2(x,y)) + " -> " + str(gridToWorld(Vector2(x,y)))
				add_child(label)

func gridToWorld(_pos: Vector2,_middlep: bool = false) -> Vector2:
	var result = origin + (_pos * cell_size)
	if _middlep:
		result += Vector2(cell_size/2.0,cell_size/2.0)
	# print("gridToWorld: ",_pos, "(", _middlep," -> ",result)
	return result

func worldToGrid(_pos: Vector2) -> Vector2:
	return floor((_pos - origin) / cell_size)
