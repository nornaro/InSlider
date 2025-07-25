extends TextureRect

func _on_button_pressed() -> void:
	if $HBoxContainer/LineEdit.text.to_upper() != "YES":
		return
	accept()
	
func accept() ->void:
	Global.warnings_accepted["Volume"] = 1
	hide()
	if %Unlock.button_pressed:
		$"../Center/Lines/Volume/HSlider".hide()
		$"../Center/Lines/Volume/TextEdit".show()
		return
	$"../Center/Lines/Volume/HSlider".show()
	$"../Center/Lines/Volume/TextEdit".hide()

func _on_decline_pressed() -> void:
	%Unlock.button_pressed = false
	Global.warnings_accepted["Volume"] = 0
	hide()
