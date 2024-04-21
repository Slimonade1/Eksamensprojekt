extends Control

# Declare member variables here. Examples:
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://civilgames.dk/db_eksamens_projekt.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const SECRET_KEY = "myPasswordNoStealPlsDDU!"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false

onready var textEdit = $CanvasLayer/TextEdit
onready var timeLabel = $CanvasLayer/Time

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var time = Singletons.gameTime
	var mili = fmod(time, 1)*1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	var timeText = "%02d : %02d : %02d" % [mins,secs,mili]
	timeLabel.text = "Your time: " + String(timeText)
	
	var command = "get_times"
	var data = {"time_ofset" : 0, "time_number" : 10}
	request_queue.push_back({"command" : command, "data" : data})
	
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")


func _process(delta):
	
	if is_requesting:
		return
		
	if request_queue.empty():
		return
		
	is_requesting = true
	
	if nonce == null:
		request_nonce()
	else:
		_send_request(request_queue.pop_front())
	
	
func request_nonce():
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print({})})
	var body = "command=get_nonce&" + data
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, false, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	print("Requeste nonce")
	
		
func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var cnonce = String(Crypto.new().generate_random_bytes(32)).sha256_text()
	
	var client_hash = (nonce + cnonce + body + String(SECRET_KEY)).sha256_text()
	print(client_hash)
	nonce = null
	
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	var err = http_request.request(SERVER_URL, headers, false, HTTPClient.METHOD_POST, body)
		
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	#$TextEdit.set_text(body)
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)
	
	
func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != http_request.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	#$TextEdit.set_text(response_body)
	var response = parse_json(response_body)

	if response['error'] != "none":
		printerr("We returned error: " + response['error'])
		return
		
	if response['command'] == "get_nonce":
		nonce = response['response']['nonce']
		print("Get nonce: " + response['response']['nonce'])
		return

	if response['response']['size'] > 0:
		textEdit.set_text("")
		for n in (response['response']['size']):
			var time = float(response['response'][String(n)]['time'])/1000
			var mili = fmod(time, 1)*1000
			var secs = fmod(time, 60)
			var mins = fmod(time, 60*60) / 60
			var timeText = "%02d : %02d : %02d" % [mins,secs,mili]
			textEdit.set_text(textEdit.get_text() + String(n + 1) + ": " + String(response['response'][String(n)]['player_name']) + "\t\t" + String(timeText) + "\n")
	else:	
		textEdit.set_text("")
	
	
func _submit_time():
	if $CanvasLayer/PlayerName.text == "":
		return
	else:
		$CanvasLayer/PlayerName.editable = false
		$CanvasLayer/AddTime.disabled = true
		
		var user_name = $CanvasLayer/PlayerName.get_text()
		var time = int(timeLabel.get_text())
		var command = "add_time"
		var data = {"username" : user_name, "time" : time}
		request_queue.push_back({"command" : command, "data" : data})
		
		command = "get_times"
		data = {"time_ofset" : 0, "time_number" : 10}
		request_queue.push_back({"command" : command, "data" : data})
	



