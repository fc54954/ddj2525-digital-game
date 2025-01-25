extends Resource

class_name Inventory

signal update 
@export var slots: Array[InventorySlot]

func insert_items(item: InventoryItem, c: int):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += c
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = c
	update.emit()
	
func has_items(item: InventoryItem, c: int):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty() and itemslots[0].amount >= c:
		return true
	else:
		return false
	
func drop_items(item: InventoryItem, c: int):
	if has_items(item, c):
		var itemslots = slots.filter(func(slot): return slot.item == item)
		itemslots[0].amount -= c
		if itemslots[0].amount == 0:
			itemslots[0].item = null
		update.emit()
		
func has_items_by_name(item_name: String, c: int) -> bool:
	for slot in slots:
		if slot.item and slot.item.name == item_name and slot.amount >= c:
			return true
	return false
