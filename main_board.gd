extends Node2D

export var SOCKET_URL = "ws://127.0.0.1:3000"
#signal send_data


var _client = WebSocketClient.new()
var connected=false;

func _ready():
	_client.connect("connection_closed", self, "_on_connection_closed")
	_client.connect("connection_error", self, "_on_connection_closed")
	_client.connect("connection_established", self, "_on_connected")
	_client.connect("data_received", self, "_on_data")
	
	var err = _client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
func _process(_delta):
	_client.poll()
	
	
	
	
func _on_connection_closed(was_clean = false):
	print("Closed, clean = ", was_clean)
	set_process(false)
	
func _on_connected(protocol = ""):
	connected=true;
	send();
	print("Connected with protocol: ", protocol)
	
func _on_data():
	var payload = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result
	print("Received data: ", payload)
	
func send():
	if connected:
		_client.get_peer(1).put_packet(JSON.print({"name": "Het"}).to_utf8())
	else:
		print("Error: Not connected to the server.")
	

