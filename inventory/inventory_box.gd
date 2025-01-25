extends Control

@onready var inv: Inventory = preload("res://inventory/inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	

func update_slots():
	for n in range(min(inv.slots.size(), slots.size())):
		slots[n].update(inv.slots[n])
	
func _process(delta: float):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()
	
	if Input.is_action_just_pressed("c") and is_open:
		close()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
