extends Area2D

@export var arc_gravity : float = 980.0   # força que puxa a garrafa para baixo (arco)
@export var spin : float = 6.0            # rotação da garrafa (só visual)

var velocity := Vector2.ZERO              # o pai define isto ao disparar

@onready var sprite = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# desaparece quando sai do ecrã
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	# movimento com aceleração constante: dá uma parábola exata
	global_position += velocity * delta + Vector2(0.0, 0.5 * arc_gravity * delta * delta)
	velocity.y += arc_gravity * delta
	sprite.rotation += spin * delta


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:  # acertou no jogador
		var scene := get_tree().current_scene
		if scene.has_method("player_hit"):
			scene.player_hit()
	queue_free()  # também desaparece ao bater no chão ou nas paredes
