extends HBoxContainer

var muted:bool
var vol: float = 0.1
#var unlocked = false

func _on_unlock_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"../../../Warning".show()
		return
	$HSlider.show()
	$TextEdit.hide()

func _on_text_edit_text_changed() -> void:
	vol = float($TextEdit.text)/10.0
	set_volume()

func mute() -> void:
	if muted:
		set_volume()
		muted = false
		return
	%Move.volume_linear = 0.0
	%BGM_player.volume_linear = 0.0
	muted = true

func _on_h_slider_value_changed(value: float) -> void:
	vol = float($HSlider.value/10)
	set_volume()
	
func set_volume() -> void:
	if vol > 1.0:
		if Global.warnings_accepted["Volume"] < 0:
			$"../../../Warning".show()
			vol = 1.0
		if Global.warnings_accepted["Volume"] == 0:
			vol = 1.0
	%Move.volume_linear = vol
	%BGM_player.volume_linear = vol
	$TextEdit.text = str(vol)
	$HSlider.value = vol * 10
