extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fallfromtree()
	
func fallfromtree():
	$AnimationPlayer.play("wood falling")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 wood")
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
