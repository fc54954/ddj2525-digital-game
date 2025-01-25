extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_number: Label = $CenterContainer/Panel/Label
@onready var g: ColorRect = $Sprite2D/Green
@onready var r: ColorRect = $Sprite2D/Red
signal buy

func _ready() -> void:
	g.visible = false
	r.visible = false


func lock():
	g.visible = false
	r.visible = true

func unlock():
	r.visible = false
	g.visible = true

func available():
	return g.visible

func _on_button_button_down() -> void:
	buy.emit()

func setup():
	if amount_number.text as int == 0:
		item_visual.visible = false
		amount_number.visible = false
