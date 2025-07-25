extends Node

var color: Color = Color(55,63,67)
var size:int = 4
var difficulty:int = 1
var type:int = 1
var volume:int = 10
var bgm:String = ""
var vol:float
var lang:Dictionary
var local:String = "en"
var warnings_accepted:Dictionary = {"Volume":-1}

func _ready() -> void:
	for l:String in DirAccess.get_files_at("res://lang/"):
		lang[l.split(".")[0]] = JSON.parse_string(FileAccess.get_file_as_string("res://lang/"+l))
