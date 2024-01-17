extends Area2D
class_name Fleet

var team:String = "UNKNOWN"
var population:float = 0
var speed:int = 150
var source = null
var target = null

func _on_area_entered(other):
#	print(name," got area_entered with an ", other.get_parent().get_class())
	if other in get_tree().get_nodes_in_group("planets") and other != source:
		_land_on_planet(other)

func _land_on_planet(planet):
		# var population_new = planet.population_current
		if planet.team == team:
			planet.population_current += population
		else:
			planet.population_current -= population
		if planet.population_current <= 0:
			planet.remove_from_group("planets_" + planet.team)
			planet.team = team
			planet.add_to_group("planets_" + planet.team)
			planet.population_current *= -1
		clamp(planet.population_current,0,planet.population_max)
		queue_free()
		
func setup(_team:String, _population:int, _source, _target):
	team = _team
	population = _population
	target = _target
	source = _source
#	print("from ", source.position, " to ",target.position)
	var _direction:Vector2 = (target.position - source.position).normalized()
	position = source.position + (_direction * (source.population_max + population ))
	self.add_to_group("fleets")
	self.add_to_group("fleets_" + team)
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("fleets")

func _process(delta):
	$CollisionShape2D.shape.radius = population
	
	if target and is_instance_valid(target):
		# Are we in the planet's core for some reason?
		if (target.position - position).length() < 1:
			_land_on_planet(target)
		else:
			var _direction:Vector2 = (target.position - position).normalized()
			position = position + (_direction * speed) * delta

func _draw():
	draw_circle(Vector2(0,0), population, Teams.get_team_color(team))
