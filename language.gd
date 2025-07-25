extends HBoxContainer

func _ready() -> void:
	%Language_select.add_item("en")
	for key:String in Global.lang.keys():
		if key == "en":
			continue
		%Language_select.add_item(key)
