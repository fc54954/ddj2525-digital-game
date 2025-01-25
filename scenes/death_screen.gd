extends Control


var menu_scene = "res://scenes/menu.tscn"
var play_scene = "res://scenes/world.tscn"
var instructions = "res://scenes/instructions.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene)


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file(instructions)
