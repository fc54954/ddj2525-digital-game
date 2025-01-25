extends Marker2D
class_name EnemySpawner
@export var enemy_scene : PackedScene
@export var spawn_time = 10
@onready var max = 3
var current = 0

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = spawn_time
	timer.start()
	
	timer.timeout.connect(spawn_enemy)
	
	
func spawn_enemy():
	if (current < max):
		var new_enemy = enemy_scene.instantiate()
		owner.add_child(new_enemy)
		current += 1
		new_enemy.died.connect(_on_enemy_died)
		new_enemy.global_position = global_position

func _on_enemy_died():
	current -= 1 
