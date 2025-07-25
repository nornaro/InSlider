extends Node

@onready var option_button: OptionButton = $OptionButton
@onready var bgm_tress: Array = [
	preload("res://BGM/Acoustic Guitar.tres"),
	preload("res://BGM/Bubble Baby.tres"),
	preload("res://BGM/Bubble Energy.tres"),
	preload("res://BGM/Bubbles.tres"),
	preload("res://BGM/Happy Pop.tres"),
	preload("res://BGM/Sugar Rush Delight.tres")
]

var bgm_tracks: Array[Dictionary] = []
var play_order: Array[int] = []
var current_index: int = 0
var bgm_history:Array[int] = [0]
var bgm_num:int = 0

func _ready() -> void:
	%BGM_player.volume_db = -20
	load_bgm_files()
	populate_option_button()
	play_next()

func load_bgm_files() -> void:
	bgm_from_tres()
	bgm_from_path(["./BGM/", "user://BGM/"])

func bgm_from_tres() -> void:
	for bgm_tres:Resource in bgm_tress:
		bgm_tracks.append({
			"name": bgm_tres.resource_path.get_file().split(".")[0],
			"stream": bgm_tres
		})

func bgm_from_path(paths:Array[String]) -> void:
	for path:String in paths:
		if !DirAccess.dir_exists_absolute(path):
			continue
		for file_name in DirAccess.get_files_at(path):
			if !file_name.ends_with(".mp3"):
				continue
			bgm_tracks.append({
				"name": file_name.split(".")[0],
				"stream": load(path + file_name) as AudioStream
			})

func populate_option_button() -> void:
	option_button.clear()
	for track in bgm_tracks:
		option_button.add_item(track["name"])

func play_next(nxt:int = bgm_num+1) -> void:
	if nxt == bgm_history.size():
		var track_index:int# = randi() % bgm_tracks.size()
		while track_index == bgm_history[bgm_num]:
			track_index = randi() % bgm_tracks.size()
		bgm_history.append(track_index)
	play_track(bgm_history[nxt])
	bgm_num += 1

func play_track(index: int) -> void:
	if index < 0 or index >= bgm_tracks.size():
		return

	var track:Dictionary = bgm_tracks[index]
	%BGM_player.stream = track["stream"]
	%BGM_player.play()
	option_button.select(index)

func _on_option_button_item_selected(index: int) -> void:
	play_track(index)

func _on_loop_toggled(toggled_on: bool) -> void:
	%BGM_player.set("parameters/looping",toggled_on)

func _on_bgm_finished() -> void:
	play_next()
