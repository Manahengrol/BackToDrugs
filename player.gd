extends CharacterBody2D

const velocidade = 300.0
const velocidade_salto = -900.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left := false

@onready var sprite = $AnimatedSprite2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = velocidade_salto

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * velocidade
		facing_left = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)

	move_and_slide()
	update_animation(direction)


# Escolhe UMA animação por frame e só chama play() quando ela muda,
# senão a animação reinicia sempre no primeiro frame.
func update_animation(direction: float) -> void:
	var anim: StringName
	if not is_on_floor():
		anim = &"jump left" if facing_left else &"jump"
	elif direction != 0:
		anim = &"walk left" if facing_left else &"walk"
	else:
		anim = &"idle"

	if sprite.animation != anim:
		sprite.play(anim)
