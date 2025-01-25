extends Control

@onready var crft: CraftMenu = preload("res://Crafting/player_craft_menu.tres")
@onready var slots: Array = $NinePatchRect/Items.get_children()
@onready var crafts: Array = $NinePatchRect/Crafts.get_children()
@export var inv: Inventory = preload("res://inventory/inventory.tres")
var is_open = false

func _ready():
	for i in range(min(crft.items.size(), slots.size())):
		slots[i].item_visual.texture = crft.items[i].item.texture
		slots[i].amount_number.text = str(crft.items[i].amount)
		slots[i].buy.connect(func(): buyItem(i))
		var recipe = crafts[i].get_children()
		for j in range(min(recipe.size(), crft.items[i].cost_items.size())):
			recipe[j].item_visual.texture = crft.items[i].cost_items[j].texture
			recipe[j].amount_number.text = str(crft.items[i].cost_amounts[j])
	inv.update.connect(update_slots)
	initial_setup()
	update_slots()
	close()
	
func initial_setup():
	for i in range(slots.size()):
		slots[i].setup()
		var res = crafts[i].get_children()
		for j in range(res.size()):
			res[j].setup()
	
	
func update_slots():
	for i in range(min(crft.items.size(), slots.size())):
		var can_craft = true
		var recipe = crafts[i].get_children()
		for j in range(min(recipe.size(), crft.items[i].cost_items.size())):
			if inv.has_items(crft.items[i].cost_items[j], crft.items[i].cost_amounts[j]):
				recipe[j].unlock()
			else:
				recipe[j].lock()
				can_craft = false
		if can_craft:
			slots[i].unlock()
		else:
			slots[i].lock()
	
func _process(delta: float):
	if Input.is_action_just_pressed("c"):
		if is_open:
			close()
		else:
			open()
	
	if Input.is_action_just_pressed("i") and is_open:
		close()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

func buyItem(i: int):

	var item = slots[i]
	if !item.available():
		return
	var craft = crft.items[i]
	for j in range(min(crafts[i].get_children().size(),craft.cost_items.size())):
		inv.drop_items(craft.cost_items[j], craft.cost_amounts[j])
	
	inv.insert_items(craft.item, craft.amount)
