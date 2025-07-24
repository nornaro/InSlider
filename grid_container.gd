extends GridContainer

var group: ButtonGroup = ButtonGroup.new()
var menu_index: int = 0
var menu: Button

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var deadzone: float = 10.0

func _ready() -> void:
	start()

func start() -> void:
	clear_children()

	Global.size = clamp(Global.size, 1, 256)
	columns = Global.size
	var count: int = Global.size * Global.size - 1  # Menü gomb miatt -1

	var type_button := $"../Menu/Center/Lines/Type/OptionButton"

	if type_button.selected == 0:
		match Global.difficulty:
			0, 1:
				demo(count)
			2:
				hard(count)
			3:
				Global.size = 5
				columns = Global.size
				count = Global.size * Global.size - 1
				extreme(count)
	if type_button.selected == 1:
		var max_size: int = 16

		Global.size = clamp(Global.size, 1, max_size)
		columns = Global.size
		count = Global.size * Global.size - 1
		match Global.difficulty:
			0, 1:
				demo_colors(count)
			2:
				hard_colors(count)
			3:
				extreme_colors(count)

	if Global.difficulty > 0:
		shuffle_buttons()
	sort_children_by_name()
	add_menu()
	

func add_menu() -> void:
	menu = Button.new()
	menu.flat = true
	add_child(menu)
	menu.text = ""
	menu.name = "Menu"
	menu.focus_mode = Control.FOCUS_NONE
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.size_flags_vertical = Control.SIZE_EXPAND_FILL
	menu_index = menu.get_index()

func _create_btn(text := "", tooltip := "", name := "", color := Color(1, 1, 1), stylebox := false) -> void:
	var btn := Button.new()
	btn.set("theme_override_font_sizes/font_size", 100/sqrt(Global.size*2))
	add_child(btn)
	btn.text = text
	btn.tooltip_text = tooltip
	btn.name = name
	btn.modulate = color
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if stylebox:
		btn.add_theme_stylebox_override("normal", StyleBoxFlat.new())

func demo(count: int) -> void:
	for i in count:
		var label := str(i + 1)
		_create_btn(label, "", label)

func hard(count: int) -> void:
	var values: Array[float] = []
	while values.size() < count:
		var num:float = snapped(randf_range(0.1, 9999.9), 0.01)
		var str_num := str(num).rstrip("0").rstrip(".")
		if str_num.length() > 4:
			continue
		values.append(num)
	values.sort()
	for num in values:
		var label := str(num).rstrip("0").rstrip(".")
		_create_btn(label, "", label)

func extreme(count: int) -> void:
	var lang:Array = Global.lang[Global.local]
	var selected := lang.slice(0, min(count, lang.size()))
	for c: Dictionary in selected:
		var name:String = c["name"]
		var tooltip := "%s\n%s\n%s" % [name, c["value"], c["desc"]]
		_create_btn(name, tooltip, name)

func demo_colors(count: int) -> void:
	var colors := _generate_demo_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color.linear_to_srgb())
		var name := str(color.r + color.g + color.b)
		_create_btn("", tooltip, name, color, true)

func hard_colors(count: int) -> void:
	var colors := _generate_hard_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color)
		var name := str(color.r + color.g + color.b)
		_create_btn("", tooltip, name, color, true)

func extreme_colors(count: int) -> void:
	var colors := _generate_extreme_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color)
		var name := str(color.r + color.g + color.b)
		_create_btn("", tooltip, name, color, true)

func _generate_demo_colors(count: int) -> Array[Color]:
	var c:Color
	while c == Color.BLACK:
		c = Color(randi() % 2,randi() % 2,randi() % 2)
	var colors: Array[Color] = []
	for i in range(count):
		var t: float = float(i) / max(1, count - 1)
		var value: float = lerp(0.0, 1.0, t)
		colors.append(Color(value, value, value) * c)
	return colors

func _generate_hard_colors(count: int) -> Array[Color]:
	var colors: Array[Color] = []
	for i in range(count):
		var c:Color
		while c == Color.BLACK:
			c = Color(randi() % 2,randi() % 2,randi() % 2)
		var t:float = float(i) / max(1, count - 1)
		colors.append(Color(lerp(0.2, 0.9, t), lerp(0.2, 0.9, t), lerp(0.2, 0.9, t)) * c)
	return colors


func _generate_extreme_colors(count: int) -> Array[Color]:
	var colors: Array[Color] = []
	for i in range(count):
		colors.append(Color(randf(), randf(), randf()))
	colors.sort_custom(Callable(self, "_compare_color_sum"))
	return colors

func _compare_color_sum(a: Color, b: Color) -> int:
	var sum_a: float = a.r + a.g + a.b
	var sum_b: float = b.r + b.g + b.b
	return signi(int(sum_b - sum_a))

func signi(x: float) -> int:
	return -1 if x < 0 else (1 if x > 0 else 0)

func _color_lerp(a: Color, b: Color, t: float) -> Color:
	return Color(
		lerp(a.r, b.r, t),
		lerp(a.g, b.g, t),
		lerp(a.b, b.b, t),
		lerp(a.a, b.a, t)
	)

func clear_children() -> void:
	for child in get_children():
		child.queue_free()

func shuffle_buttons() -> void:
	var buttons: Array[Node] = get_children()
	buttons.shuffle()
	for btn in buttons:
		remove_child(btn)
		add_child(btn)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		%Menu.visible = !%Menu.visible
		return
	if event.is_action_pressed("mute"):
		%Volume.mute()
		return
	if not (
		event.is_action_pressed("ui_left") or 
		event.is_action_pressed("ui_right") or 
		event.is_action_pressed("ui_up") or 
		event.is_action_pressed("ui_down")):
		return
	move_it(event.as_text())

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_double_tap():
		%Menu.visible = !%Menu.visible
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_start = event.position
	elif event is InputEventMouseMotion and dragging:
		var diff: Vector2 = event.position - drag_start
		if diff.length() > deadzone:
			handle_drag_direction(diff)
			dragging = false

func move_it(event_text: String) -> void:
	var index: int = menu.get_index()
	var target: int = -1
	match event_text:
		"Right":
			if index % Global.size > 0:
				target = index - 1
		"Left":
			if index % Global.size < Global.size - 1:
				target = index + 1
		"Down":
			if index >= Global.size:
				target = index - Global.size
		"Up":
			if index < Global.size * (Global.size - 1):
				target = index + Global.size
	if target >= 0 and target < get_child_count():
		var btn: Control = get_child(target)
		move_child(menu, target)
		move_child(btn, index)
		%Move.swoosh()

func handle_drag_direction(diff: Vector2) -> void:
	if abs(diff.x) > abs(diff.y):
		move_it("Right" if diff.x > 0 else "Left")
	else:
		move_it("Down" if diff.y > 0 else "Up")
		
func sort_children_by_name() -> void:
	# Get all child nodes
	var children:Array[Node] = get_children()
	
	# Sort the children by their name (using the custom comparison function)
	#children.sort_custom(_compare_children_by_name)
	
	# Reorder children after sorting
	for i in range(children.size()):
		move_child(children[i], i)

# Helper function to compare nodes by their name
func _compare_children_by_name(a: Node, b: Node) -> int:
	# Skip sorting if one of the names is "Menu"
	if a.name == "Menu" and b.name == "Menu":
		return 0
	elif a.name == "Menu":
		return -1
	elif b.name == "Menu":
		return 1
	
	# Try converting names to float for sorting as numbers
	var name_a:String = String(a.name)
	var name_b:String = String(b.name)

	var float_a:float = name_a.to_float()
	var float_b:float = name_b.to_float()
	
	if float_a < float_b:
		return -1
	elif float_a > float_b:
		return 1
	else:
		return 0
