extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	self.top_level = true
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	var display_size: Vector2 = get_viewport_rect().size
	position = Vector2(display_size.x/2, display_size.y/3)

	var margin_value = 300
	add_theme_constant_override("margin_top", margin_value)
	add_theme_constant_override("margin_left", margin_value)
	add_theme_constant_override("margin_bottom", margin_value)
	add_theme_constant_override("margin_right", margin_value)

	# Translucent background
	var background: ColorRect = ColorRect.new()
	background.color = Color(0, 0, 0, 0.5)
	# background.rect_size = display_size
	add_child(background)

	# Vertical box holding the menu
	var vbox: VBoxContainer = VBoxContainer.new()
	add_child(vbox)

	# Horizontal box holding the menu
	var hbox: HBoxContainer = HBoxContainer.new()
	vbox.add_child(hbox)
	hbox.add_theme_constant_override("separation", 60)

	# Vertical box holding the menu items
	var vbox_left: VBoxContainer = VBoxContainer.new()
	hbox.add_child(vbox_left)
	var vbox_middle: VBoxContainer = VBoxContainer.new()
	hbox.add_child(vbox_middle)
	var vbox_right: VBoxContainer = VBoxContainer.new()
	hbox.add_child(vbox_right)

	# player 1
	# var p1_hbox: HBoxContainer = HBoxContainer.new()
	# vbox_left.add_child(p1_hbox)
	var p1_label: Label = Label.new()
	p1_label.set_text("Player 1")
	vbox_left.add_child(p1_label)
	var p1_options: OptionButton = OptionButton.new()
	p1_options.add_item("Human")
	p1_options.add_item("AI")
	p1_options.select(0)
	vbox_middle.add_child(p1_options)
	var p1_colorpicker: ColorPickerButton = ColorPickerButton.new()
	p1_colorpicker.set_pick_color(Color(1, 0, 0))
	p1_colorpicker.set_text("Color")
	vbox_right.add_child(p1_colorpicker)

	# player 2
	# var p2_hbox: HBoxContainer = HBoxContainer.new()
	# vbox_left.add_child(p2_hbox)
	var p2_label: Label = Label.new()
	p2_label.set_text("Player 2")
	vbox_left.add_child(p2_label)
	var p2_options: OptionButton = OptionButton.new()
	p2_options.add_item("Human")
	p2_options.add_item("AI")
	p2_options.select(1)
	vbox_middle.add_child(p2_options)
	var p2_colorpicker: ColorPickerButton = ColorPickerButton.new()
	p2_colorpicker.set_pick_color(Color(0, 0, 1))
	p2_colorpicker.set_text("Color")
	vbox_right.add_child(p2_colorpicker)

	# AI Difficulty
	# var a_difficulty_hbox: HBoxContainer = HBoxContainer.new()
	# vbox_left.add_child(a_difficulty_hbox)
	var ai_difficulty_label: Label = Label.new()
	ai_difficulty_label.set_text("AI Think Speed")
	vbox_left.add_child(ai_difficulty_label)
	var ai_difficulty_options: OptionButton = OptionButton.new()
	ai_difficulty_options.add_item("Slow")
	ai_difficulty_options.add_item("Normal")
	ai_difficulty_options.add_item("Fast")
	ai_difficulty_options.select(1)
	vbox_middle.add_child(ai_difficulty_options)

	# AI parallelism
	# var a_parallelism_hbox: HBoxContainer = HBoxContainer.new()
	# vbox_left.add_child(a_parallelism_hbox)
	var ai_parallelism_label: Label = Label.new()
	ai_parallelism_label.set_text("AI Parallelism")
	vbox_left.add_child(ai_parallelism_label)
	
	# TODO: Figure out how to center the slider
	var ai_parallelism_label_vbox: VBoxContainer = VBoxContainer.new()
	vbox_middle.add_child(ai_parallelism_label_vbox)

	var ai_parallelism_options: HSlider = HSlider.new()
	ai_parallelism_options.set_min(1)
	ai_parallelism_options.set_max(8)
	ai_parallelism_options.set_step(1)
	ai_parallelism_options.set_value(1)
	ai_parallelism_label_vbox.add_child(ai_parallelism_options)

	if Global.game_mode == Global.GameMode.ATTRACT:
		var instructions_start_label: Label = Label.new()
		instructions_start_label.set_text("Press <enter> to start")
		vbox.add_child(instructions_start_label)

	if Global.game_mode == Global.GameMode.PAUSED:
		var instructions_reset_label: Label = Label.new()
		instructions_reset_label.set_text("Press <r> to reset")
		vbox.add_child(instructions_reset_label)

	var instructions_pause_label: Label = Label.new()
	instructions_pause_label.set_text("Press <p> to pause/unpause")
	vbox.add_child(instructions_pause_label)

	var instructions_quit_label: Label = Label.new()
	instructions_quit_label.set_text("Press <q> to quit")
	vbox.add_child(instructions_quit_label)

	# var f = load("res://fonts/PS_Hyperspace/Hyperspace.otf")
	# add_theme_font_override("font", f)
	# add_theme_font_size_override("font_size", 64)
	# print(f)
	pass
	# var new_font: DynamicFont = DynamicFont.new()
	# new_font.font_data = load("res://fonts/barlow/Barlow-Bold.ttf")
	# new_font.size = 16
	# $"RichTextLabel".set("custom_fonts/normal_font", new_font)

# When the pause button is pressed, pause the game
func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_pause"):
		Global.game_paused = !Global.game_paused
	if event is InputEventKey and event.is_action_pressed("ui_quit"):
		get_tree().quit()
	if event is InputEventKey and event.is_action_pressed("ui_accept") and Global.game_mode != Global.GameMode.PLAYING:
		Global.game_mode = Global.GameMode.PLAYING
		get_parent().start()
	if event is InputEventKey and event.is_action_pressed("ui_reset") and Global.game_mode == Global.GameMode.PLAYING:
		Global.game_mode = Global.GameMode.ATTRACT
		get_parent().start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.game_mode == Global.GameMode.ATTRACT:
		self.show()
		get_tree().paused = false
	else:
		if Global.game_paused:
			self.show()
			get_tree().paused = true
		else:
			self.hide()
			get_tree().paused = false
