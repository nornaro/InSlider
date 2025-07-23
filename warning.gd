extends TextureRect


func _on_button_pressed() -> void:
	if $HBoxContainer/LineEdit.text.to_upper() != "YES":
		return
	$"../Center/Lines/Volume/HSlider".hide()
	$"../Center/Lines/Volume/TextEdit".show()
	hide()
