extends CharacterBody2D

var speed = 100
var max_hp= 100
var hp 
var player_state
@export var inventory: Inventory
@onready var snow = $"/root/World/neve" 
@onready var rain = $"/root/World/rain" 
var bow_equiped = false
var bow_cd = true
var sword_equiped = false
var can_damage = true
var sword_damage = 20
var enemies_in_hitbox = []
var arrow = preload("res://scenes/arrow.tscn")
var bowItem = preload("res://inventory/items/Bow.tres")
var arrowItem = preload("res://inventory/items/arrow.tres")
var swordItem = preload("res://inventory/items/sword.tres")
var regen_time = 3
var timer
var dead = false

func _ready() -> void:
	inventory.update.connect(checkSword)
	$Healthbar.init_health(max_hp)
	hp = max_hp
	timer = regen_time


func _physics_process(_delta):
	if alive():
		timer -= _delta
		if timer <= 0:
			hp += 5
			hp = min(hp, max_hp)
			$Healthbar.health = hp
			timer = regen_time

		var direction = Input.get_vector("left", "right", "up", "down")
		
		if direction.x == 0 and direction.y == 0:
			player_state = "idle"
		elif direction.x != 0 or direction.y != 0:
			player_state = "walking"

		velocity = direction * speed 
		move_and_slide()
		
		if Input.is_action_just_pressed("bow") and inventory.has_items(bowItem, 1):
			if bow_equiped:
				bow_equiped = false
				$Bow.visible = bow_equiped
			else:
				sword_equiped = false
				bow_equiped = true
				$Sword.visible = sword_equiped
				$Bow.visible = bow_equiped
				
		if Input.is_action_just_pressed("sword"):
			if sword_equiped:
				sword_equiped = false
				$Sword.visible = sword_equiped
			else:
				bow_equiped = false
				sword_equiped = true
				$Bow.visible = bow_equiped
				$Sword.visible = sword_equiped
				
		
		var aim_mouse = get_global_mouse_position()
		$Marker2D.look_at(aim_mouse)
		if Input.is_action_just_pressed("mouse1") and bow_cd and bow_equiped and inventory.has_items(arrowItem, 1):
			bow_cd = false
			inventory.drop_items(arrowItem, 1)
			var arrow_inst = arrow.instantiate()
			arrow_inst.rotation = $Marker2D.rotation
			arrow_inst.global_position = $Marker2D.global_position
			add_child(arrow_inst)
			await get_tree().create_timer(1.0).timeout
			bow_cd = true
			
		if Input.is_action_just_pressed("mouse1") and sword_equiped:
			if !can_damage:
				return
			can_damage = false
			for e in enemies_in_hitbox:
				e.take_damage(sword_damage)
			$Slash.visible = true
			$Slash.play("default")
			await get_tree().create_timer(0.75).timeout
			can_damage = true
			
			
			
		play_anim(direction)

func play_anim(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("walk-up")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk-right")
			$Sword.scale.x = 1
			$Sword.position.x = abs($Sword.position.x)
			$Slash.scale.x = 0.1
			$Slash.position.x = abs($Slash.position.x)

		if dir.y == 1:
			$AnimatedSprite2D.play("walk-down")
		if dir.x == -1:
			$AnimatedSprite2D.play("walk-left")
			$Sword.scale.x = -1
			$Sword.position.x = abs($Sword.position.x) * -1 
			$Slash.scale.x = -0.1
			$Slash.position.x = abs($Slash.position.x) * -1 

func player():
	pass

func collect_item(item):
	inventory.insert_items(item, 1)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_slash_animation_finished() -> void:
	$Slash.visible = false
	
func set_speed(new_speed: float):
	speed = new_speed


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("drop_item"):  # Only track objects in the "enemies" group
		enemies_in_hitbox.append(body)


func _on_sword_body_exited(body: Node2D) -> void:
	if body in enemies_in_hitbox:  # Remove the enemy if it leaves the hitbox
		enemies_in_hitbox.erase(body)
		
func checkSword():
	if sword_damage == 50:
		return
	if inventory.has_items_by_name("GoldenSword", 1):
		$Sword/SwordSprite.texture = $Sword.swords["gold_sword"]["texture"]
		$Sword/SwordSprite.scale.x = $Sword.swords["gold_sword"]["scale"]
		$Sword/SwordSprite.scale.y = $Sword.swords["gold_sword"]["scale"]
		sword_damage = $Sword.swords["gold_sword"]["damage"]
	elif inventory.has_items_by_name("Sword", 1):
		$Sword/SwordSprite.texture = $Sword.swords["sword"]["texture"]
		$Sword/SwordSprite.scale.x = $Sword.swords["sword"]["scale"]
		$Sword/SwordSprite.scale.y = $Sword.swords["sword"]["scale"]
		sword_damage = $Sword.swords["sword"]["damage"]

func take_damage(damage: int):
	hp -= damage
	$Healthbar.health = hp
	if hp <= 0:
		die()

func die():
	dead = true
	print("Player morreu!")
	$Sword.visible = false
	$Bow.visible = false
	$"Death Screen".visible = true
	$AnimatedSprite2D.rotate(PI/2)
	rain.queue_free()
	snow.queue_free()
	#queue_free()  # Remove o jogador da cena ou reinicie o nível    
	
func alive():
	return !dead
