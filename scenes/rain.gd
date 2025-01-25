extends Node2D

@onready var player = $"/root/World/Player" 
@onready var thunder_sound = $ThunderSound  # Nó de som da trovoada
@onready var dark_overlay = $ColorRect  # ColorRect para escurecer o ambiente
var rain_probability = 0.005
var rain_duration = 20  

func _ready():
	$CPUParticles2D.emitting = false  # Garante que a chuva começa desativada
	thunder_sound.stop()  # Garante que o som começa desativado
	dark_overlay.visible = false  # Garante que o ambiente começa claro
	check_rain()  

func _process(delta):
	if player != null:
		global_position = player.global_position

func check_rain():
	if randf() < rain_probability: 
		start_rain()
	else:
		# Aguarda 1 segundo e verifica novamente
		get_tree().create_timer(1.0).timeout.connect(check_rain)

func start_rain():
	print("Chuva começou!")
	$CPUParticles2D.emitting = true
	thunder_sound.play()  # Inicia o som contínuo de trovoada
	dark_overlay.visible = true  # Escurece o ambiente

	# Reduz a velocidade do jogador, se existir
	if player != null:
		player.set_speed(player.speed * 0.6)

	# Aguarda a duração da chuva
	await get_tree().create_timer(rain_duration).timeout
	stop_rain()

func stop_rain():
	print("Chuva parou!")
	$CPUParticles2D.emitting = false
	thunder_sound.stop()  # Para o som contínuo de trovoada
	dark_overlay.visible = false  # Clareia o ambiente

	# Restaura a velocidade do jogador, se existir
	if player != null:
		player.set_speed(player.speed / 0.6)  # Retorna à velocidade original

	# Volta a verificar se a chuva deve começar novamente
	check_rain()
