extends ColorPicker

func _on_color_changed(c: Color) -> void:
	$"../../Panel".self_modulate = c
	$"../../Menu/Center/Lines/Color/Button".modulate = c
