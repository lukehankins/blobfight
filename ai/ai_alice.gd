extends "res://ai/ai.gd"

func _process(_delta):
	pass

func take_action():
	var planets = get_tree().get_nodes_in_group("planets")
	var my_planets = get_tree().get_nodes_in_group("planets_"+team)
	my_planets.sort_custom(func(a, b): return a.population_current < b.population_current)
	var barbarians = Utils.subtract_list(planets,my_planets)
	
	var fleets = get_tree().get_nodes_in_group("fleets")
	var my_fleets = get_tree().get_nodes_in_group("fleets_"+team)
	var barbarian_fleets = Utils.subtract_list(fleets,my_fleets)
	
	if barbarians and my_planets:
			# Look for my planets at risk
			if len(my_planets) > 1:
				for p in my_planets:
					if _total_fleets_attcking(p, barbarian_fleets, my_fleets) > p.population_current:
						# Send from the most populated planet (except the one at risk)
						var possible_planets = Utils.subtract_list(my_planets, [p])
						var my_planet = _get_populatedest(possible_planets)
						# print("AIA rescuing ", my_planet, " -> ", p)
						my_planet.send_fleet(p)
						return

			# Look for the closest planet I can grab
			# Send from the most populated planet
			var my_planet = _get_populatedest(my_planets)
			var victim = _get_closest(my_planet, barbarians)
			# print("AIA sending to closest ", my_planet, " -> ", victim)
			my_planet.send_fleet(victim)
