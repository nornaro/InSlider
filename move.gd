extends AudioStreamPlayer


func swoosh() -> void:
	pitch_scale = randf_range(0.95,1.05)
	play()
