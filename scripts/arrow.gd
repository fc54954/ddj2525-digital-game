extends Area2D

var speed = 250
var distance = 200
var pos = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	pos = position
	
func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("default")
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	if position.distance_to(pos) >= distance:
		queue_free()
	

func arrow_damage():
	pass
