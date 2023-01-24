extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var my_node

func _ready():
	my_node = get_node("Path/To/MyNode2D")
	my_node.connect("send_data", self, "_on_send_data")

func _on_some_event():
	my_node.emit_signal("send_data")

func _on_send_data():
	print("send data function called")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	my_node.emit_signal("send")
	#print("nnn")

