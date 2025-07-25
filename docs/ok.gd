extends Button

func _ready() -> void:
	_on_pressed()

func _on_pressed() -> void:
	Global.size = int($"../../Size/Text".text)
	Global.difficulty = $"../../Difficulty/OptionButton".selected
	Global.local = $"../../Language/OptionButton".get_item_text($"../../Language/OptionButton".selected)
	%Menu.hide()
	%Field.start()
	%Field.queue_sort()

func localize() -> void:
	$"../../Color/Label".text = Global.lang[Global.local]["Color"]
	$"../../Size/Label".text = Global.lang[Global.local]["Size"]
	$"../../Volume/HBoxContainer/Label".text = Global.lang[Global.local]["Volume"]
	$"../../Volume/HBoxContainer/Unlock".tooltip_text = Global.lang[Global.local]["Unlock"]
