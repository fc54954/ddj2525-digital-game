extends Node2D

@onready var player = $"/root/World/Player" 
@onready var thunder_sound = $SnowSound 
@onready var fog_image = $Sprite2D
@onready var dark_overlay = $ColorRect
var rain_probability = 0.0025
var rain_duration = 30  

func _ready():
	$CPUParticles2D.emitting = false  
	thunder_sound.stop() 
	fog_image.visible = false
	dark_overlay.visible = false
	check_rain()  
	
	
func _process(delta):
	if player != null:
		global_position = player.global_position  
	

func check_rain():
	if randf() < rain_probability: 
		start_rain()
	else:
		
		get_tree().create_timer(1.0).timeout.connect(check_rain)

func start_rain():
	print("Chuva começou!")
	$CPUParticles2D.emitting = true
	thunder_sound.play()  
	print("Chuva começou! A ligar  luz...")
	dark_overlay.visible = true
	fog_image.visible = true
	
	await get_tree().create_timer(rain_duration).timeout
	stop_rain()

func stop_rain():
	print("Chuva parou!")
	$CPUParticles2D.emitting = false
	thunder_sound.stop()  
	dark_overlay.visible = false  
	fog_image.visible = false  


	
	check_rain()
