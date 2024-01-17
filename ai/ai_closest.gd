extends "res://ai/ai.gd"

func _process(_delta):
	pass

func take_action():
	var planets = get_tree().get_nodes_in_group("planets")
	var my_planets = get_tree().get_nodes_in_group("planets_"+team)
	my_planets.shuffle()
	var barbarians = Utils.subtract_list(planets,my_planets)

	if barbarians and my_planets:
		for i in range(min(action_parallel,my_planets.size())):
			var my_planet = my_planets[i]
			var victim = _get_closest(my_planet, barbarians)
			print("AIC sending ", my_planet, " -> ", victim)
			my_planet.send_fleet(victim)
