extends Button

func _ready() -> void:
	_on_pressed()

func _on_pressed() -> void:
	Global.size = int(%Size_text.text)
	Global.difficulty = %Difficulty_select.selected
	Global.local = %Language_select.get_item_text(%Language_select.selected)
	%Menu.hide()
	%Field.start()
	%Field.queue_sort()

func localize() -> void:
	%Color_label.text = Global.lang[Global.local]["Color"]
	%Size_label.text = Global.lang[Global.local]["Size"]
	%Volume_label.text = Global.lang[Global.local]["Volume"]
	%Unlock.tooltip_text = Global.lang[Global.local]["Unlock"]
