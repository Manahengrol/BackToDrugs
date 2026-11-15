extends AnimatedSprite2D

@export var cerveja : PackedScene = preload("res://projectile.tscn")
@export var start_interval := 1.5   # segundos entre garrafas no início
@export var spam_interval := 0.3    # segundos entre garrafas no modo spam
@export var spam_after := 10.0      # segundos até ele começar a fazer spam
@export var aim_spread := 60.0      # erro aleatório (em pixels) onde a garrafa cai
@export var flight_time_min := 1.0  # tempo de voo da garrafa (mais tempo = arco mais alto)
@export var flight_time_max := 1.4

var _elapsed := 0.0
var _cooldown := 0.0

@onready var player: Node2D = get_parent().get_node_or_null("Player")


func _ready() -> void:
	_cooldown = start_interval


func _physics_process(delta: float) -> void:
	_elapsed += delta
	var interval := spam_interval if _elapsed >= spam_after else start_interval
	# minf: quando o spam começa, o próximo tiro não espera pelo intervalo antigo
	_cooldown = minf(_cooldown - delta, interval)
	if _cooldown <= 0.0:
		_shot_arrow()
		_cooldown = interval


func _shot_arrow() -> void:
	if not cerveja or not player:
		return
	var cervejinha = cerveja.instantiate()
	get_tree().current_scene.add_child(cervejinha)
	cervejinha.global_position = global_position

	# alvo: o centro do corpo do jogador, com um pequeno erro para a esquerda/direita
	var target: Node2D = player.get_node_or_null("CollisionShape2D")
	if not target:
		target = player
	var to_target: Vector2 = target.global_position - global_position
	to_target.x += randf_range(-aim_spread, aim_spread)

	# Calcula a velocidade inicial para a garrafa chegar ao alvo ao fim de t segundos.
	# x = vx·t   e   y = vy·t + ½·g·t²   (y para baixo é positivo)
	var t := randf_range(flight_time_min, flight_time_max)
	cervejinha.velocity = Vector2(
		to_target.x / t,
		(to_target.y - 0.5 * cervejinha.arc_gravity * t * t) / t
	)
