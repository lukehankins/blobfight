extends "space.gd"

# var grid: Grid

# var left_planet
# var right_planet

func _ready():
	randomize()
	Engine.set_max_fps(60)

	Grid.tightness = 10
	Grid.generateGrid()

	var Planet = preload("res://entity/planet.tscn")
	# var AIR = preload("res://ai/ai_random.tscn")
	# var AIC = preload("res://ai/ai_closest.tscn")
	var AIA = preload("res://ai/ai_alice.tscn")
#
#	left_planet = Planet.instantiate().setup("green", Grid.left_home)
#	left_planet.birthrate *= 5
#	left_planet.name = left_planet.team
#	add_child(left_planet)
#
#	var left_ai = AIA.instantiate()
#	left_planet.add_child(left_ai)
##	left_ai.action_parallel = 1
#	left_ai.setup()
#
#	right_planet = Planet.instantiate().setup("red", Grid.right_home)
#	right_planet.birthrate *= 5
#	right_planet.name = right_planet.team
#	add_child(right_planet)
#
##	var right_ai = AIR.instantiate()
###	right_ai.action_parallel = 2
##	right_planet.add_child(right_ai)
##	right_ai.setup()
	
	Global.teams = ["red", "green", "blue", "orange", "purple", "yellow"]
	for x in range(Grid.x_slot_count):
		for y in range(Grid.y_slot_count):
			var jitter = Vector2((randi() % Grid.cell_size)-(Grid.cell_size/2.0),(randi() % Grid.cell_size)-(Grid.cell_size/2.0)) / 2
			var team = Global.teams[randi() % Global.teams.size()]
			var planet = Planet.instantiate().setup(team, Grid.gridToWorld(Vector2(x,y),true) + jitter)
			planet.birthrate = 3
			add_child(planet)
			var ai = AIA.instantiate()
			ai.action_wait = 4
			planet.add_child(ai)
			ai.setup()

# func _handle_menu
func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	_draw_score_bar()
