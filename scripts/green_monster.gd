extends CharacterBody2D

var speed = 120
var hp = 100
var isDead = false
var player_in_area = false
var player 
var flag = false
signal died
@onready var ironDrop = $EnemyDrop
@onready var gasDrop = $EnemyDrop_gas
@export var ironResource: InventoryItem
@export var gasResource: InventoryItem
var timer = 0.75

func _ready() -> void:
	isDead = false
	
func _physics_process(delta: float) -> void:
	if !isDead:
		$PlayerDetection/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("movement")
		else:
			$AnimatedSprite2D.play("idle")
		
		if flag:
			if timer == 0.75 && player.alive():
				player.take_damage(10)
			timer -= delta
			if timer <= 0:
				timer = 0.75
	
		
	if isDead:
		$PlayerDetection/CollisionShape2D.disabled = true
		


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body
		


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		

func take_damage(dmg):
	hp = hp - dmg
	$Blood.visible = true
	$Blood.play("default")
	if hp <= 0 and !isDead:
		death()
		
func death():
	isDead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	emit_signal("died") 
	drop_item()
	$AnimatedSprite2D.visible = false
	$Hitbox/CollisionShape2D.disabled = true
	$PlayerDetection/CollisionShape2D.disabled = true
	



func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage
	if area.has_method("bullet_damage") or area.has_method("arrow_damage"):
		damage = 50
		take_damage(damage)
		
func drop_item():
	var drop_chance = randi() % 100
	if drop_chance < 20:
		ironDrop.visible = true
		$collect_area/CollisionShape2D.disabled = false
		item_collect(ironResource)
	elif drop_chance < 25:
		gasDrop.visible = true
		$collect_area/CollisionShape2D.disabled = false
		item_collect(gasResource)
	else:
		queue_free()
	
func item_collect(itemResource: InventoryItem):
	await get_tree().create_timer(2).timeout
	ironDrop.visible = false
	gasDrop.visible = false
	player.collect_item(itemResource)
	queue_free()


func _on_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body


func enemy():
	pass


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		flag = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		flag = false


func _on_blood_animation_finished() -> void:
	$Blood.visible = false
