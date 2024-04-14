extends Node2D

var grid: Grid

# var teams = []

var left_planet
var right_planet

func start() -> void:

	for f in get_tree().get_nodes_in_group("fleets"):
		f.remove_from_group("fleets")
		f.queue_free()
	for p in get_tree().get_nodes_in_group("planets"):
		p.remove_from_group("planets")
		p.queue_free()


	if Global.game_mode == Global.GameMode.ATTRACT:
		Grid.tightness = 10
		Grid.generateGrid()
	
		var Planet = preload("res://entity/planet.tscn")
		# var AIR = preload("res://ai/ai_random.tscn")
		# var AIC = preload("res://ai/ai_closest.tscn")
		var AIA = preload("res://ai/ai_alice.tscn")
	
		for p in get_tree().get_nodes_in_group("planets"):
			p.queue_free()
	
		Global.players = { "red": { "name": "red", "color": Color(255,0,0), "brain": "AI" },
							"green": { "name": "green", "color": Color(0,255,0), "brain": "AI" },
							"blue": { "name": "blue", "color": Color(0,0,255), "brain": "AI" },
							"orange": { "name": "orange", "color": Color(255,128,0), "brain": "AI" },
							"purple": { "name": "purple", "color": Color(0.56027537584305, 0.09232837706804, 0.77364259958267), "brain": "AI" },
							"yellow": { "name": "yellow", "color":Color("YELLOW"), "brain": "AI" } }
		Global.teams = Global.players.keys()
			
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
	else:
		Grid.tightness = 6
		Grid.generateGrid()

		var Planet = preload("res://entity/planet.tscn")
		# var AIR = preload("res://ai/ai_random.tscn")
		# var AIC = preload("res://ai/ai_closest.tscn")
		var AIA = preload("res://ai/ai_alice.tscn")
		
		left_planet = Planet.instantiate().setup("green", Grid.left_home)
		left_planet.birthrate *= 5
		left_planet.name = left_planet.team
		add_child(left_planet)
		
		var left_ai = AIA.instantiate()
		left_planet.add_child(left_ai)
	#	left_ai.action_parallel = 1
		left_ai.setup()
		
		right_planet = Planet.instantiate().setup("red", Grid.right_home)
		right_planet.birthrate *= 5
		right_planet.name = right_planet.team
		add_child(right_planet)
		
	#	var right_ai = AIR.instantiate()
	##	right_ai.action_parallel = 2
	#	right_planet.add_child(right_ai)
	#	right_ai.setup()
			
		for x in range(Grid.x_slot_count):
			for y in range(Grid.y_slot_count):
				var jitter = Vector2((randi() % Grid.cell_size)-(Grid.cell_size/2.0),(randi() % Grid.cell_size)-(Grid.cell_size/2.0)) / 2
				var planet = Planet.instantiate().setup("NEUTRAL", Grid.gridToWorld(Vector2(x,y),true) + jitter)
				add_child(planet)

		Global.teams = [left_planet.team, "NEUTRAL", right_planet.team]

func _ready():
	Engine.set_max_fps(60)
	randomize()
	start()

func _check_for_end_of_game() -> void:
	var teams_alive = []
	for p in get_tree().get_nodes_in_group("planets"):
		if not teams_alive.has(p.team):
			teams_alive.append(p.team)
	if teams_alive.size() == 1:
		print("GAME OVER: "+teams_alive[0]+" WINS")
		Global.game_mode = Global.GameMode.ATTRACT
		start()

func _process(_delta: float) -> void:
	_check_for_end_of_game()
	queue_redraw()

func _draw_score_bar() -> void:

	var score = {}
	score["total"] = 0

	for team_name in Global.teams:
		score["p"+team_name] = 0
		score["f"+team_name] = 0
	
	for team_name in Global.teams:
		for planet in get_tree().get_nodes_in_group("planets_"+team_name):
			score["p"+planet.team] += planet.population_current
			score["total"] += planet.population_current

	for team_name in Global.teams:
		for fleet in get_tree().get_nodes_in_group("fleets_"+team_name):
			score["f"+fleet.team] += fleet.population
			score["total"] += fleet.population

	var score_bar_from = Vector2(Grid.left_home.x,Grid.y_margin*0.75)
	var score_bar_to = Vector2(Grid.right_home.x,Grid.y_margin*0.75)
	
	const planet_bar_height = 16
	const fleet_bar_height = 8

	var score_bar_now = score_bar_from
	var score_bar_order = []
	for team_name in Global.teams:
		score_bar_order.append(["p"+team_name,team_name,planet_bar_height])
		score_bar_order.append(["f"+team_name,team_name,fleet_bar_height])

	for item in score_bar_order:
		var percent = score[item[0]] / score["total"]
		var bar_vec = (score_bar_to - score_bar_from) * percent
		draw_line(score_bar_now,score_bar_now+bar_vec,Teams.get_team_color(item[1]),item[2])
		score_bar_now = score_bar_now+bar_vec



func _draw() -> void:
	# Draw a score bar

	_draw_score_bar()

	# Draw a grid for debugging
	if false:
		var display_size = get_viewport_rect().size
		for x in range(0,display_size.x,100):
			draw_line(Vector2(x,0),Vector2(x,display_size.y),Color(30,30,30))
		for y in range(0,display_size.y,100):
			draw_line(Vector2(0,y),Vector2(display_size.x,y),Color(30,30,30))
