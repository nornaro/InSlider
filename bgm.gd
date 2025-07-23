extends Node

@onready var bgm_player: AudioStreamPlayer = %BGM
@onready var option_button: OptionButton = $OptionButton

# Store track dictionaries with "name" and "stream"
var bgm_tracks: Array[Dictionary] = []
var play_order: Array[int] = []
var current_index: int = 0
var is_manual_selection: bool = false

func _ready() -> void:
	%BGM.volume_linear = 0.1
	load_bgm_files(find_mp3_in_known_paths())
	populate_option_button()
	shuffle_play_order()
	play_next()

func find_mp3_in_known_paths() -> String:
	var paths := ["./BGM/", "res://BGM/", "user://BGM/"]

	for path:String in paths:
		if not DirAccess.dir_exists_absolute(path):
			continue
		var files := DirAccess.get_files_at(path)
		for file in files:
			if file.to_lower().ends_with(".mp3"):
				return path
	return ""

func load_bgm_files(path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open BGM directory!")
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".mp3"):
			var file_path: String = path + file_name
			var stream: Resource = load(file_path)
			if stream is AudioStream:
				var base_name: String = file_name.replace(".mp3", "")
				bgm_tracks.append({
					"name": base_name,
					"stream": stream
				})
		file_name = dir.get_next()
	dir.list_dir_end()

func populate_option_button() -> void:
	option_button.clear()
	for track in bgm_tracks:
		option_button.add_item(track["name"])

func shuffle_play_order() -> void:
	play_order.clear()
	for i in bgm_tracks.size():
		play_order.append(i)
	play_order.shuffle()
	current_index = 0

func play_next() -> void:
	if bgm_tracks.is_empty():
		return

	var track_index: int = play_order[current_index]
	play_track(track_index)
	
	if !$HBoxContainer/Loop:
		current_index += 1
	if current_index >= play_order.size():
		shuffle_play_order()

func play_track(index: int) -> void:
	if index < 0 or index >= bgm_tracks.size():
		return

	var track: Dictionary = bgm_tracks[index]
	bgm_player.stream = track["stream"]
	bgm_player.play()

	# Update OptionButton without triggering signal callback
	is_manual_selection = true
	option_button.select(index)
	is_manual_selection = false

func _on_BGM_finished() -> void:
	play_next()


func _on_option_button_item_selected(index: int) -> void:
	play_track(index)
