extends StaticBody2D

@export var item: InventoryItem
var player = null 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_collect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func player_collect():
	player.collect_item(item)
