extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_number: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if !slot.item:
		item_visual.visible = false
		amount_number.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount >= 1:
			amount_number.visible = true
			amount_number.text = str(slot.amount)
