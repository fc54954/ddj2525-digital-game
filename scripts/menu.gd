extends Node

var menu_scene = "res://scenes/menu.tscn"
var play_scene = "res://scenes/world.tscn"
var instructions = "res://scenes/instructions.tscn"

func go_to_menu():
	get_tree().change_scene_to_file(menu_scene)
	
func go_to_play():
	get_tree().change_scene_to_file(play_scene)

func exit_game():
	get_tree().quit()


func _on_play_pressed() -> void:
	go_to_play()


func _on_exit_pressed() -> void:
	exit_game()


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file(instructions)
