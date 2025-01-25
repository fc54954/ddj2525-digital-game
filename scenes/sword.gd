extends Area2D

@onready var swords = {
	"basic_knife": {
		"damage": 20,
		"scale": 0.45,
		"texture": preload("res://images/weapons/Scimitar_Silver.png")
	},
	"sword": {
		"damage": 25,
		"scale": 0.6,
		"texture": preload("res://images/weapons/Falchion_Silver.png")
	},
	"gold_sword": {
		"damage": 50,
		"scale": 0.6,
		"texture": preload("res://images/weapons/Zweihander_Gold.png")
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
