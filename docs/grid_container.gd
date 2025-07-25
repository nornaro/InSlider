extends GridContainer

var group: ButtonGroup = ButtonGroup.new()
var menu_index: int = 0
var menu: Button
var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var deadzone: float = 10.0
var tutorial:int = -1
var min_color:float
var max_color:float

func _ready() -> void:
	start()

func start() -> void:
	clear_children()

	Global.size = clamp(Global.size, 1, 256)
	columns = Global.size
	var count: int = Global.size * Global.size - 1  # Menü gomb miatt -1
	var type_button := $"../Menu/Center/Lines/Type/OptionButton"

	min_color = 1.0/count
	max_color = 1.0-min_color

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

func _create_btn(text:String = "", tooltip:String = "", btn_name:String = "", color:Color = Color(1, 1, 1), stylebox:bool = false) -> void:
	var btn := Button.new()
	btn.set("theme_override_font_sizes/font_size", 100/sqrt(Global.size*2))
	add_child(btn)
	btn.text = text
	btn.tooltip_text = tooltip
	btn.name = btn_name
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
		var btn_name:String = c["name"]
		var tooltip := "%s\n%s\n%s" % [btn_name, c["value"], c["desc"]]
		_create_btn(btn_name, tooltip, btn_name)

func demo_colors(count: int) -> void:
	var colors := _generate_demo_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color)
		var btn_name := str(int(floor(color.r*255)+floor(color.g*255)+floor(color.b*255)))
		_create_btn("", tooltip, btn_name, color, true)

func hard_colors(count: int) -> void:
	var colors := _generate_hard_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color)
		var btn_name := str(int(floor(color.r*255)+floor(color.g*255)+floor(color.b*255)))
		_create_btn("", tooltip, btn_name, color, true)

func extreme_colors(count: int) -> void:
	var colors := _generate_extreme_colors(count)
	for i in count:
		var color := colors[i]
		var tooltip := str(color)
		var btn_name := str(int(floor(color.r*255)+floor(color.g*255)+floor(color.b*255)))
		_create_btn("", tooltip, btn_name, color, true)

func _generate_demo_colors(count: int) -> Array[Color]:
	var c:Color
	while c == Color.BLACK:
		c = Color(randi() % 2,randi() % 2,randi() % 2)
	var colors: Array[Color] = []
	for i in range(count):
		var t: float = float(i) / max(1, count - 1)
		var value: float = lerp(min_color, max_color, t)
		colors.append(Color(value, value, value) * c)
	return colors

func _generate_hard_colors(count: int) -> Array[Color]:
	var colors: Array[Color] = []
	for i in range(count):
		var c:Color
		while c == Color.BLACK:
			c = Color(randi() % 2,randi() % 2,randi() % 2)
		var t:float = float(i) / max(1, count - 1)
		colors.append(Color(lerp(min_color, max_color, t), lerp(min_color, max_color, t), lerp(min_color, max_color, t)) * c)
	return colors

func _generate_extreme_colors(count: int) -> Array[Color]:
	var colors: Array[Color] = []
	for i in range(count):
		colors.append(Color(randf_range(min_color, max_color), randf_range(min_color, max_color), randf_range(min_color, max_color)))
	return colors

func _compare_color_sum(a: Color, b: Color) -> int:
	var sum_a: float = a.r + a.g + a.b
	var sum_b: float = b.r + b.g + b.b
	return signi(int(sum_b - sum_a))

func signi(x: float) -> int:
	return -1 if x < 0 else (1 if x > 0 else 0)

#func _color_lerp(a: Color, b: Color, t: float) -> Color:
	#return Color(
		#lerp(a.r, b.r, t),
		#lerp(a.g, b.g, t),
		#lerp(a.b, b.b, t),
		#lerp(a.a, b.a, t)
	#)

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
	if (event.is_action_pressed("ui_left") or 
		event.is_action_pressed("ui_right") or 
		event.is_action_pressed("ui_up") or 
		event.is_action_pressed("ui_down")):
		move_it(event.as_text())
		return
	if event.is_action_pressed("vol-"):
		%Volume.vol -= 0.05
		%Volume.set_volume()
		return
	if event.is_action_pressed("vol+") :
		%Volume.vol += 0.05
		%Volume.set_volume()
		return
	if event.is_action_pressed("ui_page_down"):
		%BGM.bgm_num = clamp(%BGM.bgm_num-2,0,%BGM.bgm_history.size())
		%BGM.play_next()
		return
	if event.is_action_pressed("ui_page_up"):
		%BGM.play_next()
		return

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if !event.is_double_tap():
			return
		%Menu.visible = !%Menu.visible
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				drag_start = event.position
			return
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if tutorial == -1:
				return
			if !Input.is_action_just_pressed("rmb"):
				return
			%Tutorial_timer.emit_signal("timeout")
			%Tutorial_timer.start(3)
		return
	if event is InputEventMouseMotion and dragging:
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
	if tutorial == 1:
		if get_child(0).name != "1":
			return
		%Tutorial_fade.play("Fade_out")
		fade("Nice!. Let's see the part 2!")
		tutorial2()
		return
	if tutorial == 2:
		var children:Array[int]
		for child:Node in get_children():
			if child.name.contains("Menu"): continue
			children.append(int(child.name))
		if get_child(0).name != str(children.min()):
			return
		%Tutorial_fade.play("Fade_out")
		fade("Tutorial complete. Well done!")
		tutorial = -1
		%Tutorial_timer.stop()
		return
		

func handle_drag_direction(diff: Vector2) -> void:
	if abs(abs(diff.x) - abs(diff.y)) < 5:
		return
	if abs(diff.x) > abs(diff.y):
		move_it("Right" if diff.x > 0 else "Left")
		return
	move_it("Down" if diff.y > 0 else "Up")
		
func sort_children_by_name() -> void:
	var children:Array[Node] = get_children()
	for i in range(children.size()):
		move_child(children[i], i)

func _compare_children_by_name(a: Node, b: Node) -> int:
	if a.name == "Menu" and b.name == "Menu":
		return 0
	if a.name == "Menu":
		return -1
	if b.name == "Menu":
		return 1
	
	var name_a:String = String(a.name)
	var name_b:String = String(b.name)
	var float_a:float = name_a.to_float()
	var float_b:float = name_b.to_float()
	
	if float_a < float_b:
		return -1
	if float_a > float_b:
		return 1
	return 0

func _on_button_pressed() -> void:
	tutorial = 0
	$"../Menu/Center/Lines/Type/OptionButton".select(0)
	%Tutorial_timer.start(3)
	Global.size = 3
	Global.difficulty = 0
	$"../Tutorial_overlay".show()
	%Menu.hide()
	%Field.start()
	fade("Tutorial")
	await %Tutorial_timer.timeout
	fade("Goal is to sort tiles to ascending order")
	await %Tutorial_timer.timeout
	fade("The field is randomized at start")
	for btn_name:String in ["5","6","7","8","Menu","1","2","3","4"]:
		var btn:Node = get_node(btn_name)
		remove_child(btn)
		add_child(btn)
	tutorial = 1
	await %Tutorial_timer.timeout
	fade("Let's move the 1 to the top left")
	await %Tutorial_timer.timeout
	fade("To move a tile, swipe, or use arrows")
	await %Tutorial_timer.timeout
	fade("Follow directions")
	await %Tutorial_timer.timeout
	fade("Or feel free to try yourself")
	await %Tutorial_timer.timeout
	%Tutorial_text.text = ("Example: ← ↓ → ↑ → ↓, →, ←")
	%Tutorial_fade.play("Fade_in")
	
func tutorial2() -> void:
	await %Tutorial_timer.timeout
	fade("Second mode is using RGB colors")
	$"../Menu/Center/Lines/Type/OptionButton".select(1)
	%Field.start()
	await %Tutorial_timer.timeout
	fade("Move the darkest to the top left")
	shuffle_buttons()
	tutorial = 2
	$"../Tutorial_overlay".hide()
	
func fade(txt:String) -> void:
	%Tutorial_text.text = txt
	%Tutorial_fade.play("Fade")
	
