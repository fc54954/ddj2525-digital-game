extends Node2D

var state = "ready"
var player_in_area = false
var player = null

@export var object_type: String = "tree"  # Tipo do objeto: "tree" ou "rock"
@export var resource_scene: PackedScene  # Caminho para o item a ser gerado
@export var item: InventoryItem  # Item a ser coletado

func _ready():
	if state == "ready":
		$Timer.start()

func _process(delta):
	if state == "not ready":
		$AnimatedSprite2D.play("%s_broken" % object_type)  # Animação "tree_broken" ou "rock_broken"
	if state == "ready":
		$AnimatedSprite2D.play(object_type)  # Animação "tree" ou "rock"
		if player_in_area:
			if Input.is_action_just_pressed("e"):  # Detecta a tecla "E"
				state = "not ready"
				drop_resource()

func _on_looting_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		player = body

func _on_looting_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false

func _on_Timer_timeout() -> void:
	if state == "not ready":
		state = "ready"

func drop_resource():
	var resource_instance = resource_scene.instantiate()  # Instancia o item configurado
	resource_instance.global_position = $Marker2D.global_position  # Define a posição do item
	get_parent().add_child(resource_instance)  # Adiciona o item à cena
	player.collect_item(item)  # Adiciona o item ao inventário do jogador
	await get_tree().create_timer(3).timeout
	$Timer.start()
