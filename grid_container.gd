extends GridContainer

var group: ButtonGroup = ButtonGroup.new()
var menu_index: int = 0
var menu: Button

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var deadzone: float = 10.0

var constants: Array[Dictionary] = [
	# (változatlanul meghagyva a konstansokat)
	{"name": "pi", "value": "3.1415926536", "desc": "The ratio of a circle's circumference to its diameter, a fundamental mathematical constant appearing in geometry, trigonometry, and many other fields."},
	{"name": "tau", "value": "6.2831853072", "desc": "Tau constant, equal to 2 times pi (2π), often used in circle-related calculations and considered by some to be more natural than pi."},
	{"name": "e", "value": "2.7182818285", "desc": "Euler's number, the base of the natural logarithm, crucial in exponential growth, differential equations, and complex analysis."},
	{"name": "phi", "value": "1.6180339887", "desc": "The golden ratio, a special number often found in art, architecture, and nature, associated with aesthetically pleasing proportions."},
	{"name": "sqrt2", "value": "1.4142135624", "desc": "Square root of 2, one of the first known irrational numbers, frequently appearing in the Pythagorean theorem."},
	{"name": "sqrt3", "value": "1.7320508076", "desc": "Square root of 3, commonly encountered in geometric calculations, such as the height of an equilateral triangle."},
	{"name": "ln2", "value": "0.6931471806", "desc": "Natural logarithm of 2, often used in exponential and logarithmic calculations."},
	{"name": "ln10", "value": "2.3025850930", "desc": "Natural logarithm of 10, connecting the base-10 logarithm to the natural logarithm."},
	{"name": "gamma", "value": "0.5772156649", "desc": "Euler–Mascheroni constant, significant in number theory and analysis, especially in problems related to prime number distribution."},
	{"name": "c", "value": "299792458", "desc": "Speed of light in vacuum in meters per second, a fundamental physical constant central to relativity theory."},
	{"name": "h", "value": "6.62607015e-34", "desc": "Planck constant, foundational in quantum mechanics, relating energy and frequency."},
	{"name": "ħ", "value": "1.054571817e-34", "desc": "Reduced Planck constant (Dirac constant), equal to Planck constant divided by 2π, important in quantum mechanics formulas."},
	{"name": "G", "value": "6.67430e-11", "desc": "Gravitational constant, determining the strength of gravitational force between masses in Newton's law of universal gravitation."},
	{"name": "k", "value": "1.380649e-23", "desc": "Boltzmann constant, linking temperature and energy in statistical physics."},
	{"name": "Na", "value": "6.02214076e+23", "desc": "Avogadro's number, the number of constituent particles (usually atoms or molecules) in one mole of substance."},
	{"name": "qe", "value": "1.602176634e-19", "desc": "Elementary charge, the magnitude of electric charge carried by a proton or electron, fundamental to electromagnetism."},
	{"name": "me", "value": "9.10938356e-31", "desc": "Electron mass in kilograms, fundamental particle mass."},
	{"name": "mp", "value": "1.6726219e-27", "desc": "Proton mass in kilograms, constituent of atomic nuclei."},
	{"name": "μ0", "value": "1.25663706212e-6", "desc": "Vacuum permeability (magnetic constant), defines the magnetic properties of vacuum."},
	{"name": "ε0", "value": "8.854187817e-12", "desc": "Vacuum permittivity (electric constant), characterizes the electric properties of vacuum."},
	{"name": "σ", "value": "5.670374419e-8", "desc": "Stefan–Boltzmann constant, relates the total energy radiated per unit surface area of a black body to the fourth power of its temperature."},
	{"name": "R", "value": "8.314462618", "desc": "Ideal gas constant, relates pressure, volume, and temperature of an ideal gas."},
	{"name": "g", "value": "9.80665", "desc": "Standard acceleration due to gravity on Earth's surface in meters per second squared."},
	{"name": "alpha", "value": "0.0072973526", "desc": "Fine-structure constant, a dimensionless constant characterizing the strength of electromagnetic interaction."}
]

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
		var max_size: int = 16 if Global.difficulty <= 1 else 256

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

func demo(count: int) -> void:
	for i in range(count):
		var btn: Button = Button.new()
		add_child(btn)
		btn.text = str(i + 1)
		btn.name = btn.text
		btn.modulate = Color(1, 1, 1)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func hard(count: int) -> void:
	var values: Array[float] = []
	while values.size() < count:
		var num: float = snapped(randf_range(0.1, 9999.9), 0.01)
		var str_num: String = str(num).rstrip("0").rstrip(".")
		if str_num.length() <= 4:
			values.append(num)
	values.sort()
	for num in values:
		var btn: Button = Button.new()
		add_child(btn)
		var label: String = str(num).rstrip("0").rstrip(".")
		btn.text = label
		btn.name = label
		btn.modulate = Color(1, 1, 1)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func extreme(count: int) -> void:
	var selected: Array = constants.slice(0, min(count, constants.size()))
	for c in selected:
		var btn: Button = Button.new()
		add_child(btn)
		btn.text = c["name"]
		btn.name = c["name"]
		btn.tooltip_text = "%s\n%s\n%s" % [c["name"], c["value"], c["desc"]]
		btn.modulate = Color(1, 1, 1)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func demo_colors(count: int) -> void:
	var colors: Array[Color] = _generate_demo_colors(count)
	for i in range(count):
		var btn: Button = Button.new()
		add_child(btn)
		btn.add_theme_stylebox_override("normal", StyleBoxFlat.new())
		btn.text = ""
		btn.tooltip_text = str(colors[i].linear_to_srgb())
		btn.name = str(colors[i].r+colors[i].b+colors[i].g)
		btn.modulate = colors[i]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func hard_colors(count: int) -> void:
	var colors: Array[Color] = _generate_hard_colors(count)
	for i in range(count):
		var btn: Button = Button.new()
		add_child(btn)
		btn.add_theme_stylebox_override("normal", StyleBoxFlat.new())
		btn.text = ""
		btn.tooltip_text = str(colors[i])
		btn.name = str(colors[i].r+colors[i].b+colors[i].g)
		btn.modulate = colors[i]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func extreme_colors(count: int) -> void:
	var colors: Array[Color] = _generate_extreme_colors(count)
	for i in range(count):
		var btn: Button = Button.new()
		add_child(btn)
		btn.add_theme_stylebox_override("normal", StyleBoxFlat.new())
		btn.text = ""
		btn.tooltip_text = str(colors[i])
		btn.name = str(colors[i].r+colors[i].b+colors[i].g)
		btn.modulate = colors[i]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

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
		var t = float(i) / max(1, count - 1)
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
	return signi(sum_b - sum_a)

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
	if not (event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")):
		return
	move_it(event.as_text())

func _input(event: InputEvent) -> void:
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
		
func sort_children_by_name():
	# Get all child nodes
	var children = get_children()
	
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
	var name_a = String(a.name)
	var name_b = String(b.name)

	var float_a = name_a.to_float()
	var float_b = name_b.to_float()
	
	if float_a < float_b:
		return -1
	elif float_a > float_b:
		return 1
	else:
		return 0
