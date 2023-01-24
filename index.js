var ws = require('ws')

var server = new ws.Server({port: 3000})
let lobby=[]
let board = {'1':"no", '2':"no", '3':"no", '4':"no", '5':"no", '6':"no", '7':"no", '8':"no", '9':"no"}
let turn = 1;
let count = 0;
let state = 'Null';
let latest_pos='Null';
let pos_entry='Null';

server.on('connection', server => {
	lobby.push(server);
	server.on('message', message => {
		let data = JSON.parse(message);
		console.log(data);
        
        if(data!="het connected"){
            count=data['count'];
            board[data['latest_pos']]=data['latest_entry'];
            latest_pos=data['latest_pos'];
            pos_entry=data['latest_entry'];
            console.log(board)
            if(turn == 1) {
                turn = 0
                
            }

            else {
                turn = 1
                
            }
        }
        else{
            console.log("hahahhaahhah")
        }

        

	});

    
	server.on('close', (code, reason) => {
		console.log(code, reason);
		const index = lobby.indexOf(ws);
        lobby.splice(index, 1);

	});

	if (lobby.length >= 2) {
        // Match up the first two players in the lobby
        const player1 = lobby.shift();
        const player2 = lobby.shift();
        console.log('works')

        // Send message to start the game
        // player1.send(JSON.stringify({ type: 'start', mark: 'X' }));
        // player2.send(JSON.stringify({ type: 'start', mark: 'O' }));

        // // Keep track of the players' game state
        // player1.gameState = { mark: 'X', opponent: player2 };
        // player2.gameState = { mark: 'O', opponent: player1 };
        player1.send(JSON.stringify({ 'isX' : 'True', isTurn : 'True', 'pos':latest_pos,'pos_entry' : pos_entry, 'count' : count, 'state': state }));
        player2.send(JSON.stringify({ 'isX' : 'False', isTurn : 'False','pos':latest_pos, 'pos_entry' : pos_entry, 'count' : count, 'state': state }));

        setInterval(() => {
            // turn =int(count)%2;
            if (checkWin() == 'X') {
             state = 'X'
     
             }
     
             else if (checkWin() == 'O') {
                 state = 'O'
             }
     
             else if(checkWin() == 'Draw' && count >= 9) {
                 state = 'D'
             }
     
             else {
                 state = 'Null'
             }
             
             if (turn == 1) {
                 player1.send(JSON.stringify({ 'isX' : 'True', isTurn : 'True', 'pos':latest_pos,'pos_entry' : pos_entry, 'count' : count, 'state': state }));
     
                 player2.send(JSON.stringify({ 'isX' : 'False', isTurn : 'False','pos':latest_pos, 'pos_entry' : pos_entry, 'count' : count, 'state': state }));
                 
             }
             else {
                 player2.send(JSON.stringify({ 'isX' : 'False', isTurn : 'True','pos':latest_pos, 'pos_entry' : pos_entry, 'count' : count, 'state': state }));
                 player1.send(JSON.stringify({ 'isX' : 'True', isTurn : 'False','pos':latest_pos,'pos_entry' : pos_entry, 'count' : count, 'state': state }));
             }
             if(state!='Null'){
                board = {'1':"no", '2':"no", '3':"no", '4':"no", '5':"no", '6':"no", '7':"no", '8':"no", '9':"no"}
                turn = 1;
                count = 0;
                state = 'Null';
                latest_pos='Null';
                pos_entry='Null';
             }
           }, 100);
    }

    

	
});

function checkWin() {
    var winningCombinations = [
        [1, 2, 3], [4, 5, 6], [7, 8, 9], // rows
        [1, 4, 7], [2, 5, 8], [3, 6, 9], // columns
        [1, 5, 9], [3, 5, 7]  // diagonals
    ];
    for (var i = 0; i < winningCombinations.length; i++) {
        var combination = winningCombinations[i];
        if (board[combination[0]] === "X" && board[combination[1]] === "X" && board[combination[2]] === "X") {
            return "X";
        }
        if (board[combination[0]] === "O" && board[combination[1]] === "O" && board[combination[2]] === "O") {
            return "O";
        }
    }
    return "Draw";
}
