extends Node

var timer:Timer
var action_wait:float = 1
var action_wait_jitter:float = 0.5
var action_parallel:int = 1

var team:String = "UNKNOWN"

func setup():
	team = get_parent().team
	timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	timer.start(action_wait + randf_range(0-action_wait_jitter,action_wait_jitter))
	var me = self
	me.take_action()
	# self.take_action()
	return self

# Called when the node enters the scene tree for the first time.
func _ready():

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	var me = self
	me.take_action()
	pass

func _total_fleets_attcking(_planet, _barbarians, _my_fleets):
	var result = 0
	for f in _barbarians:
		result += f.population
	for f in _my_fleets:
		result -= f.population
	return result

func _get_populatedest(_list:Array, _exclude_team=[], _include_team=[]):
	var populatedest = null
	var best:float = -1
	
	for obj in _list:
		if obj.team in _exclude_team:
			print("excluding ", obj)
			continue
		if _include_team and not obj.team in _include_team:
			print("not in include ", obj)
			continue
		if obj.population_current > best:
			populatedest = obj
			best = obj.population_current
	return populatedest
	
func _get_closest(_from, _list:Array, _exclude_team=[], _include_team=[]):
	var closest = null
	var best_distance:float = 9223372036854775807.0
	
	for obj in _list:
		if obj.team in _exclude_team:
			print("excluding ", obj)
			continue
		if _include_team and not obj.team in _include_team:
			print("not in include ", obj)
			continue
		var d = abs((_from.position - obj.position).length())
		if d < best_distance:
			closest = obj
			best_distance = d
	return closest
