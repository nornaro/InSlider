extends GridContainer

var group: ButtonGroup = ButtonGroup.new()
var menu_index:int = 0
var menu: Button

var dragging := false
var drag_start := Vector2.ZERO
var deadzone := 10.0

var constants: Array[Dictionary] = [
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
	columns = Global.size
	var count:int = Global.size * Global.size
	
	if $"../Menu/Center/Lines/Type/OptionButton".selected == 0:
		match Global.difficulty:
			0:
				demo(count)
			1:
				demo(count)
			2:
				hard(count)
			3:
				Global.size = 5
				extreme(count)

	if $"../Menu/Center/Lines/Type/OptionButton".selected == 1:
		match Global.difficulty:
			0:
				Global.size = clamp(Global.size,1,16)
				demo_colors(count)
			1:
				Global.size = clamp(Global.size,1,16)
				demo_colors(count)
			2:
				Global.size = clamp(Global.size,1,256)
				hard_colors(count)
			3:
				Global.size = clamp(Global.size,1,256)
				extreme_colors(count)

	if Global.difficulty > 0:
		shuffle_buttons()
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

func demo(count:int) -> void:
	for i in count-1:
		var btn:Button = Button.new()
		add_child(btn)
		btn.text = str(i+1)
		btn.name = btn.text
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

func extreme(count: int) -> void:
	var selected = constants.slice(0, min(count, constants.size()))
	for constants in selected:
		var btn := Button.new()
		add_child(btn)
		btn.text = constants["name"]
		btn.name = constants["name"]
		btn.tooltip_text = (constants["name"]+"\n"+constants["value"]+"\n"+constants["desc"])


func hard(count: int) -> void:
	var values: Array[float] = []
	
	while values.size() < count:
		var num: float = randf_range(0.1, 9999.9)
		num = snapped(num, 0.01)  # Round to 2 decimal places

		var num_str: String = str(num)
		
		# Remove trailing zeroes in floats like 1.00 → 1, 2.10 → 2.1
		if "." in num_str:
			num_str = num_str.rstrip("0").rstrip(".")
		
		# Limit to 4 characters max (optional truncation, depends on need)
		if num_str.length() <= 4:
			values.append(num)

	# Sort numerically
	values.sort()

	# Create buttons
	for num in values:
		var btn := Button.new()
		add_child(btn)
		var label := str(num)
		if "." in label:
			label = label.rstrip("0").rstrip(".")
		btn.text = label
		btn.name = label


func clear_children() -> void:
	for child in get_children():
		child.queue_free()

func shuffle_buttons() -> void:
	var buttons := []
	
	for child in get_children():
		buttons.append(child)
	
	buttons.shuffle()

	for btn:Button in buttons:
		remove_child(btn)
		add_child(btn)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		%Menu.visible = !%Menu.visible
		return
	if event.is_action_pressed("mute"):
		%Volume.mute()
		return
	if (!event.is_action_pressed("ui_left") and
		!event.is_action_pressed("ui_right") and
		!event.is_action_pressed("ui_up") and
		!event.is_action_pressed("ui_down")):
		return
	move_it(event.as_text())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if event.pressed:
			dragging = true
			drag_start = event.position
			return
		dragging = false
	
	if event is InputEventMouseMotion:
		if !dragging:
			return
		var diff:Vector2 = event.position - drag_start
		if diff.length() > deadzone:
			handle_drag_direction(diff)
			dragging = false
	
func move_it(event_text: String) -> void:
	var index := menu.get_index()
	var target := -1
	
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
		var btn := get_child(target)
		move_child(menu, target)
		move_child(btn, index)
		%Move.swoosh()

func handle_drag_direction(diff: Vector2) -> void:
	if abs(diff.x) > abs(diff.y):
		if diff.x > 0:
			move_it("Right")
		else:
			move_it("Left")
	else:
		if diff.y > 0:
			move_it("Down")
		else:
			move_it("Up")

func demo_colors(count: int) -> Array:
	var colors := []
	
	# Véletlenszerűen válassz ki 1-3 komponenst (R,G,B)
	var components := []
	
	var comp_options = ["r", "g", "b"]
	var n_comp = randi() % 3 + 1  # 1, 2 vagy 3 komponens
	
	while components.size() < n_comp:
		var candidate = comp_options[randi() % comp_options.size()]
		if candidate not in components:
			components.append(candidate)
	
	for i in range(count):
		var t = float(i) / max(1, count - 1)
		var r = t if "r" in components else 0.0
		var g = t if "g" in components else 0.0
		var b = t if "b" in components else 0.0
		colors.append(Color(r, g, b))
	
	return colors

func hard_colors(count: int) -> Array:
	var colors := []
	var start_color = Color(1, 0, 0) # piros
	var end_color = Color(0, 0, 1)   # kék
	
	for i in range(count):
		var t = float(i) / max(1, count - 1)
		var c = color_lerp(start_color, end_color, t)
		colors.append(c)
	return colors


func extreme_colors(count: int) -> Array:
	var colors := []
	for i in range(count):
		var c = Color(randf(), randf(), randf())
		colors.append(c)
	
	# rendezés R+G+B alapján
	colors.sort_custom(_compare_color_sum)
	return colors
	
func _compare_color_sum(a: Color, b: Color) -> int:
	var sum_a = a.r + a.g + a.b
	var sum_b = b.r + b.g + b.b
	if sum_a < sum_b:
		return -1
	if sum_a > sum_b:
		return 1
	return 0

func color_lerp(a: Color, b: Color, t: float) -> Color:
	return Color(
		lerp(a.r, b.r, t),
		lerp(a.g, b.g, t),
		lerp(a.b, b.b, t),
		lerp(a.a, b.a, t)
	)
