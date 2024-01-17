extends "res://ai/ai.gd"

func _process(_delta):
	pass

func take_action():
	var planets = get_tree().get_nodes_in_group("planets")
	var my_planets = get_tree().get_nodes_in_group("planets_"+team)
	my_planets.shuffle()
	var barbarians = Utils.subtract_list(planets,my_planets)
	
	if barbarians and my_planets:
		for i in range(action_parallel):
			var my_planet = my_planets[randi() % my_planets.size()]
			var victim = barbarians[randi() % barbarians.size()]
			print("AIR sending ", my_planet, " -> ", victim)
			my_planet.send_fleet(victim)
