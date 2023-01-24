extends Node2D

var board = {'1':"no", '2':"no", '3':"no", '4':"no", '5':"no", '6':"no", '7':"no", '8':"no", '9':"no"}
export(Texture) var X
export(Texture) var O

var count = 0

export(bool) var isMyTurn = true
export(bool) var isX = true
func check_win():
	var winning_combinations = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
	for combination in winning_combinations:
		 if board[str(combination[0])] == "X" and board[str(combination[1])] == "X" and board[str(combination[2])] == "X":
		   return "X"
		 if board[str(combination[0])] == "O" and board[str(combination[1])] == "O" and board[str(combination[2])] == "O":
		   return "O"
	for i in board:
		 if(board[i]=="no"):
		   return "Null"
	return "D";

func _process(delta):
	var outcome = check_win()
	#print(board)
	var area=get_child(10)
	if isX :
		#send(board)
		area.get_node("Label").text="Turn:X"
	else:
		area.get_node("Label").text="Turn:O"
	
	if outcome == 'X':
		get_tree().change_scene("res://winscreen.tscn")
	elif outcome == 'O':
		get_tree().change_scene("res://winscreeno.tscn")
	elif (outcome == 'D'and count>=9):
		get_tree().change_scene("res://tiescreen.tscn")
		

	
func try_make_move(pos: int):
	if isMyTurn:
		if board[str(pos)]=="no":
			if isX:
				make_move(pos,"X")
				isX = false
			else:
				make_move(pos, "0")
				isX = true
				
func make_move(pos: int, turn: String):
	count+=1
	var area=get_child(pos)
	if turn == "X":
		board[str(pos)]="X"
		print(board)
		#send(board)
		area.get_node("Sprite").texture=X

		
		
	else:
		board[str(pos)]="O"
		print(board)
		area.get_node("Sprite").texture=O

	

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









func _on_Area2D10_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
