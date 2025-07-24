extends HBoxContainer

var  muted:bool
var vol: float = 10.0

func _on_unlock_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"../../../Warning".show()
		return
	$TextEdit.hide()
	$HSlider.show()

func _on_text_edit_text_changed() -> void:
	vol = float($TextEdit.text)
	%Move.volume_linear = vol
	%BGM.volume_linear = vol
	$HSlider.value = vol

func mute() -> void:
	if muted:
		%Move.volume_linear = vol
		%BGM.volume_linear = vol
		muted = false
		return
	vol = %BGM.volume_linear
	%Move.volume_linear = 0.0
	%BGM.volume_linear = 0.0
	muted = true

func _on_h_slider_value_changed(value: float) -> void:
	vol = float($HSlider.value/100)
	%Move.volume_linear = vol
	%BGM.volume_linear = vol
	$TextEdit.text = str(vol)
