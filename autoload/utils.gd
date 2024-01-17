extends Node2D

func calculate_circle_arc(_center, _radius, _angle_from, _angle_to) -> PackedVector2Array:
	var _nb_points = 64
	var _points_arc = PackedVector2Array()

	for i in range(_nb_points + 1):
		var _angle_point = deg_to_rad(_angle_from + i * (_angle_to - _angle_from) / _nb_points - 90)
		_points_arc.push_back(_center + Vector2(cos(_angle_point), sin(_angle_point)) * _radius)

	return _points_arc

func subtract_list(a: Array, b: Array) -> Array:
	var result = []
	var bag = {}
	for item in b:
		if not bag.has(item):
			bag[item] = 0
			bag[item] += 1
	for item in a:
		if bag.has(item):
			bag[item] -= 1
			if bag[item] == 0:
				bag.erase(item)
		else:
			result.append(item)
	return result
