extends Button

func _on_pressed() -> void:
	%ColorPicker.visible = !%ColorPicker.visible
	%Menu.visible = !%Menu.visible
