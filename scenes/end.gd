extends Node

@onready var inventory: Inventory = preload("res://inventory/inventory.tres")
@onready var fuel_item: InventoryItem = preload("res://scenes/fuel.tres") 
@onready var label: Label = $Label  
var menu_scene = "res://scenes/menu.tscn"
var world = "res://scenes/world.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		
		var fuel_amount = 0
		for slot in inventory.slots:
			if slot.item == fuel_item:
				fuel_amount = slot.amount
				break
		
		var missing = 3 - fuel_amount
		if fuel_amount >= 3:  
			end_game()
		else:  
			print("As gasolinas não são suficientes para escapares")
			show_message("Ainda faltam %d gasolinas!" % missing)
func show_message(text):
	label.text = text
	label.visible = true
	await get_tree().create_timer(3).timeout  
	label.visible = false

func end_game():
	print("O jogo terminou! Você apanhou 4 gasolinas.")
	get_tree().change_scene_to_file("res://scenes/end.tscn")  

func go_to_menu():
	get_tree().change_scene_to_file(menu_scene)

func try_again():
	get_tree().change_scene_to_file(world)

func _on_main_menu_pressed() -> void:
	go_to_menu()

func _on_try_again_pressed() -> void:
	try_again()
