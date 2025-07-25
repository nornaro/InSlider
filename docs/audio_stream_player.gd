extends AudioStreamPlayer

var playback
var phase = 0.0
var current_freq = 440.0
var tick = 0
const SCALE = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88] # C major
const SAMPLE_RATE = 44100


func _ready():
	var gen = AudioStreamGenerator.new()
	gen.mix_rate = SAMPLE_RATE
	stream = gen
	play()
	playback = get_stream_playback()
	set_process(true)

func _physics_process(delta: float) -> void:
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		var sample = sin(phase)
		playback.push_frame(Vector2(sample, sample) * 0.2)
		phase += 2.0 * PI * current_freq / SAMPLE_RATE
		if phase > TAU:
			phase -= TAU
		tick += 1
		if tick >= SAMPLE_RATE / 4: # kb 4 hang másodpercenként
			current_freq = SCALE[randi() % SCALE.size()]
			tick = 0
		to_fill -= 1
