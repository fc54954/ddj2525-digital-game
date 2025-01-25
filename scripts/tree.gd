extends Node2D

var state = "ready"
var player_in_area = false
var wood = preload("res://scenes/wood_item.tscn")

@export var item: InventoryItem
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == "ready":
		$wood_timer.start()
		

func _process(delta):
	if state == "not ready":
		$AnimatedSprite2D.play("tree_stem")
	if state == "ready":
		$AnimatedSprite2D.play("tree")
		if player_in_area:
			if Input.is_action_just_pressed("e"):
				state = "not ready"
				drop_wood()
				

func _on_looting_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_looting_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _on_wood_timer_timeout() -> void:
	if state == "not ready":
		state = "ready"

func drop_wood():
	var wood_instance = wood.instantiate()
	wood_instance.global_position = $Marker2D.global_position
	get_parent().add_child(wood_instance)
	player.collect_item(item)
	await get_tree().create_timer(3).timeout
	$wood_timer.start()		
