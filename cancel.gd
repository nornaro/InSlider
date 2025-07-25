extends Button

func _on_pressed() -> void:
	if %Menu.visible:
		%Menu.hide()
		return
	if %Login_screen.visible:
		%Login_screen.hide()
		return
