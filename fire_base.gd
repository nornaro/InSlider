extends Node

@onready var http_request:HTTPRequest = HTTPRequest.new()

var api_key:String = "AIzaSyBqryRQqqd3SJBY_FKmJ79EwOxrNFWVWM8"
var login_url:String = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + api_key

func _ready() -> void:
	add_child(http_request)

	var login_data:Dictionary = {
		"email": "fuyuhimematsuri@gmail.com",
		"password": "5350bf42",
		"returnSecureToken": true
	}
	var json_string:String = JSON.stringify(login_data)
	var headers:Array = ["Content-Type: application/json"]

	http_request.connect("request_completed", _on_request_completed)

	var err:int = http_request.request(login_url, headers, HTTPClient.METHOD_POST, json_string)
	if err != OK:
		print("Request error:", err)
		return
	print("Login request sent...")

func _on_request_completed(result, response_code:int , headers:Array, body) -> void:
	var text:String = body.get_string_from_utf8()
	if response_code == 200:
		print("Login success!")
		var json:Dictionary = JSON.parse_string(text)
		print("ID Token:", json["idToken"])
		print("User UID:", json["localId"])
		return
	print("Login failed:", response_code)
	print("Body:", text)

#func fetch_user_data():
	#var url := "https://inslider-ae25f-default-rtdb.europe-west1.firebasedatabase.app/user_db.json"
	#var http := HTTPRequest.new()
	#add_child(http)
	#http.request_completed.connect(_on_fetch_completed)
	#var error := http.request(url)
	#if error != OK:
		#push_error("HTTP Request failed")
#
#func _on_fetch_completed(result, response_code, headers, body):
	#if response_code != 200:
		#print("Failed to fetch:", response_code)
		#return
#
	#var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
	#if !data:
		#return
	#for user in data:
		#print(data[user])

func fetch_user_data(user_id: String,dat: String = ""):
	var url := "https://inslider-ae25f-default-rtdb.europe-west1.firebasedatabase.app/user_db/%s.json" % [user_id]
	var http := HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(_on_fetch_completed)
	var error := http.request(url)
	if error != OK:
		push_error("HTTP Request failed: %s" % error)

func _on_fetch_completed(result, response_code, headers, body) -> void:
	print("Response code:", response_code)
	if response_code != 200:
		print("Failed to fetch:", response_code)
		print("Body:", body.get_string_from_utf8())
		return
	var data:Variant = JSON.parse_string(body.get_string_from_utf8())
	match typeof(data):
		TYPE_DICTIONARY:
			Global.user = data
		TYPE_STRING:
			if !%Login_screen.visible:
				return
			if %PW_text.text != data:
				return
			Global.auth = true
			fetch_user_data(%Username.text)

#func fetch_user_data(user_id: String):
	#var url := "https://inslider-ae25f-default-rtdb.europe-west1.firebasedatabase.app/user_db/%s.json" % user_id
	#var http := HTTPRequest.new()
	#add_child(http)
	#http.request_completed.connect(_on_fetch_completed)
	#var error := http.request(url)
	#if error != OK:
		#push_error("HTTP Request failed")
#
#func _on_fetch_completed(result, response_code, headers, body):
	#if response_code != 200:
		#print("Failed to fetch:", response_code)
		#return
#
	#var data = JSON.parse_string(body.get_string_from_utf8())
	#if data.error != OK:
		#print("JSON parse error")
		#return
	#print("User data:", data.result)

func _on_button_pressed() -> void:
	fetch_user_data("sugo")

func add_user(user_id: String, mail: String, pw: String):
	var url := "https://inslider-ae25f-default-rtdb.europe-west1.firebasedatabase.app/user_db/%s.json" % user_id
	var data := {
		"mail": mail,
		"pass": pw,
		"settings": "",
		"status": ""
	}
	var json_data := JSON.stringify(data)
	var body_bytes := json_data.to_utf8_buffer()

	var headers := PackedStringArray(["Content-Type: application/json"])

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_user_added)
	http.request(url, headers, HTTPClient.METHOD_PUT, json_data)

func _on_user_added(result, response_code, headers, body):
	if response_code == 200:
		print("User added successfully")
		return
	print("Failed to add user:", response_code)

func _on_button_2_pressed() -> void:
	add_user("stevepint", "fenyőistvantamas@gmail.com", "ikari".sha1_text())
