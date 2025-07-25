extends HBoxContainer

func _ready() -> void:
	$OptionButton.add_item("en")
	for key:String in Global.lang.keys():
		if key == "en":
			continue
		$OptionButton.add_item(key)
