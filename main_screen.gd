extends Node2D

export var OnlinemainGameScene : PackedScene
export var PassGameScene : PackedScene
export var CompGameScene : PackedScene


func _on_Multiplayer_button_up():
	get_tree().change_scene(OnlinemainGameScene.resource_path)


func _on_Pass_button_up():
	get_tree().change_scene(PassGameScene.resource_path)



func _on_Computer_button_up():
	get_tree().change_scene(CompGameScene.resource_path)


func _on_quit_button_up():
	get_tree().quit()
