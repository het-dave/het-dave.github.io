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
	var y=predict_next_move()
	#yield(get_tree().create_timer(0.3), "timeout")
	ai_make_move(int(y))
		#print(board)
		#send(board)
	#print(count)
	
	var outcome = check_win()
	#print(board)
	
	if outcome == 'X':
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://winscreen.tscn")
	elif outcome == 'O':
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://winscreeno.tscn")
	elif (outcome == 'D'and count>=9):
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://tiescreen.tscn")
		
		

func ai_make_move(pos: int):
	if isMyTurn==false:
		if board[str(pos)]=="no":
			if isX:
				make_move(pos,"X")
				isX = false
			else:
				make_move(pos, "0")
				isX = true	
		isMyTurn=true;		
func try_make_move(pos: int):
	if isMyTurn:
		if board[str(pos)]=="no":
			if isX:
				make_move(pos,"X")
				isX = false
			else:
				make_move(pos, "0")
				isX = true
		isMyTurn=false;		
	
func make_move(pos: int, turn: String):
	
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
		

	count+=1	

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
	
	#computer code
	var board = {'1':"no", '2':"no", '3':"no", '4':"no", '5':"no", '6':"no", '7':"no", '8':"no", '9':"no"}
var ai_player = "O"
var opponent_player = "X"

# Function to check if the game is over
func is_game_over(board: Dictionary):
	if board['1']!="no" and board['1']==board['2'] and board['2']==board['3']:
		return true
	if board['4']!="no" and board['4']==board['5'] and board['5']==board['6']:
		return true
	if board['7']!="no" and board['7']==board['8'] and board['8']==board['9']:
		return true
	if board['1']!="no" and board['1']==board['4'] and board['4']==board['7']:
		return true
	if board['2']!="no" and board['2']==board['5'] and board['5']==board['8']:
		return true
	if board['3']!="no" and board['3']==board['6'] and board['6']==board['9']:
		return true
	if board['1']!="no" and board['1']==board['5'] and board['5']==board['9']:
		return true
	if board['3']!="no" and board['3']==board['5'] and board['5']==board['7']:
		return true
	for cell in board.keys():
		if board[cell] == "no":
			return false
	return true

# Function to check if a player has won

func checkWin(board: Dictionary, count): 
	var winningCombinations = [
		[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
		[1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
		[1, 5, 9], [3, 5, 7]  # diagonals
	];
	for i in range(len(winningCombinations)):
		var combination = winningCombinations[i];
		if (board[str(combination[0])] == "X" && board[str(combination[1])] == "X" && board[str(combination[2])] == "X"): 
			return "X";
		
		elif (board[str(combination[0])] == "O" && board[str(combination[1])] == "O" && board[str(combination[2])] == "O"): 
			return "O";
			
		elif (count == 9):
			return "D"
		
	return 'Null';

# Function to evaluate the current state of the board
# Function to evaluate the current state of the board
func evaluate(board: Dictionary):
	if is_game_over(board):
		if checkWin(board, ai_player):
			return 10
		elif checkWin(board, opponent_player):
			return -10
		else:
			return 0
	return 0
# Minimax function to determine the best move

func minimax(board: Dictionary):
	var b=[]
	for cell in board:
		if(board[cell]=="no"):
			b.append(cell)
	print(len(b))		
	if len(b)==0:
		return '1';
	else:
		randomize()
		b.shuffle()
		return b[0]
func predict_next_move():
	return minimax(board)	
