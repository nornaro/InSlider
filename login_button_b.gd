extends Button

func _on_pressed() -> void:
	if Global.auth:
		Global.user = {}
		text = "Log in"
		Global.auth = false
	if !Global.auth:
		if (%Username.text == ""):
			return
		if (%PW_text.text == ""):
			return
		var req:String = %Username.text+"/"+"pass"
		%FireBase.fetch_user_data(req)
		await get_tree().create_timer(2).timeout
		if !Global.auth:
			return
		text = "Log out"
