extends Area2D
class_name Planet

var team: String = "NEUTRAL"
var population_max: float = 50
var population_current: float = 30
var birthrate: int = 1
var selected: bool = false

var show_label: bool = false
var debug_label:Label

func setup(_team:String, _position:Vector2, _population_max:float=population_max, _population_current:float=population_current):
	team = _team
	population_max = _population_max
	population_current = _population_current
	position = _position
	self.add_to_group("planets")
	self.add_to_group("planets_" + team)
	return self

func send_fleet_if_selected(_target):
	if selected and _target != self:
		send_fleet(_target)
		
func send_fleet(_target):
	var _population_sending: float = population_current / 2
	population_current -= _population_sending
	var Fleet = preload("res://entity/fleet.tscn")
	var _fleet = Fleet.instantiate().setup(team,_population_sending,self, _target)
#	get_node("/root/Space").add_child(_fleet)
	get_parent().add_child(_fleet)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = population_max
	if show_label:
		debug_label = Label.new()
		debug_label.position = Vector2(-50,70)
		debug_label.text = str(population_current) + " / " + str(population_max)
		add_child(debug_label)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Clicking on me?
		if (event.position - position).length() < population_max:
			if event.button_index == MOUSE_BUTTON_LEFT:
				selected = true
			if event.button_index == MOUSE_BUTTON_RIGHT:
				get_tree().call_group("planets", "send_fleet_if_selected", self)
		else:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if not Input.is_key_pressed(KEY_SHIFT):
					selected = false

func _process(delta):
	var _population_growth = birthrate*delta
	population_current = min(population_current + (birthrate*delta),population_max)
	if show_label:
		debug_label.text = str(_population_growth) + " ->" + str(population_current) + " / " + str(population_max)
	queue_redraw()

func _draw():
	var arc:PackedVector2Array
	
	if selected:
		arc = Utils.calculate_circle_arc(Vector2(0,0), population_max+3, 0, 360)
		for i in range(arc.size()-1):
			draw_line(arc[i], arc[i + 1], Color("yellow"), 3)

	# Draw population_max
	arc = Utils.calculate_circle_arc(Vector2(0,0), population_max, 0, 360)
	for i in range(int((arc.size()-1)/2.0)):
		draw_line(arc[i*2], arc[i*2 + 1], Color("gray"), 1)

	# Draw population_current
	draw_circle(Vector2(0,0), population_current, Teams.get_team_color(team))


