extends Button

func _ready() -> void:
	_on_pressed()

func _on_pressed() -> void:
	Global.size = int($"../../Size/Text".text)
	Global.difficulty = $"../../Difficulty/OptionButton".selected
	%Menu.hide()
	%Field.start()
	%Field.queue_sort()
