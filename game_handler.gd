extends Node2D

var board = {'1':"no", '2':"no", '3':"no", '4':"no", '5':"no", '6':"no", '7':"no", '8':"no", '9':"no"}
var count = 0
var state = 'Null'
var mark='Null'
var latest_pos='Null'
var latest_entry='NULL'

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
	send("het connected");
	print("Connected with protocol: ", protocol)
	
func _on_data():
	var payload = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result
	print("Received data: ", payload)
	print(board)
	if(payload['pos']!='Null' and payload['pos_entry']!='Null'):
		board[payload['pos']] =payload['pos_entry']
		var area=get_child(int(payload['pos']))
		if  payload['pos_entry']=="X":
			#send(board)
			area.get_node("Sprite").texture=X
			
		else:
			area.get_node("Sprite").texture=O
		
		#print(payload['pos'],payload['pos_entry'])
	count = int(payload['count'])
	
	if(payload['isX']=='True'):
		isX = true;
		mark='X'
	else:
		isX = false;	
		mark='O'
	if(payload['isTurn']=='True'):
		isMyTurn = true;
	else:
		isMyTurn = false;	
	state = payload['state']
	if(state=='X'):
		get_tree().change_scene("res://winscreen.tscn")
	elif(state=='O'):
		get_tree().change_scene("res://winscreeno.tscn")
	elif(state!='Null'):
		get_tree().change_scene("res://tiescreen.tscn")
	
	
func send(data):
	if connected:
		_client.get_peer(1).put_packet(JSON.print(data).to_utf8())
	else:
		print("Error: Not connected to the server.")
	



export(Texture) var X
export(Texture) var O

export(bool) var isMyTurn=false;
export(bool) var isX



	
func try_make_move(pos: int):
	if isMyTurn:
		if board[str(pos)]=="no":
			if isX:
				make_move(pos,"X")
			else:
				make_move(pos, "0")
				
func make_move(pos: int, turn: String):
	count+=1
	var area=get_child(pos)
	if turn == "X":
		board[str(pos)]="X"
		print(board)
		#send(board)
		area.get_node("Sprite").texture=X
		latest_pos=str(pos)
		latest_entry='X'
		
		
	else:
		board[str(pos)]="O"
		print(board)
		area.get_node("Sprite").texture=O
		latest_pos=str(pos)
		latest_entry='O'
		
	isMyTurn = false
	send({'latest_pos':latest_pos,'latest_entry':latest_entry,'count':count,'turn':turn})

func event_handler(event: InputEvent,pos: int):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_LEFT and event.pressed:
			try_make_move(pos)




func _on_Area2D_input_event(viewport, event, shape_idx):
	event_handler(event,1)


func _on_Area2D2_input_event(viewport, event, shape_idx):
	event_handler(event,2)


func _on_Area2D3_input_event(viewport, event, shape_idx):
	event_handler(event,3)


func _on_Area2D4_input_event(viewport, event, shape_idx):
	event_handler(event,4)


func _on_Area2D5_input_event(viewport, event, shape_idx):
	event_handler(event,5)


func _on_Area2D6_input_event(viewport, event, shape_idx):
	event_handler(event,6)


func _on_Area2D7_input_event(viewport, event, shape_idx):
	event_handler(event,7)


func _on_Area2D8_input_event(viewport, event, shape_idx):
	event_handler(event,8)


func _on_Area2D9_input_event(viewport, event, shape_idx):
	event_handler(event,9)
