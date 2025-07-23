extends HBoxContainer

func _ready() -> void:
	for key:String in Global.lang.keys():
		$OptionButton.add_item(key)
	pass
