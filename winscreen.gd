extends Node2D




func _on_mainmenu_button_up():
	get_tree().change_scene("res://main_screen.tscn")


func _on_quit_button_up():
	get_tree().quit()
