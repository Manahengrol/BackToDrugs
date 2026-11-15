extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("idle")

func _physics_process(delta):
	if velocity.length() > 0:
		
		sprite.play("walk")
	else:
		sprite.play("idle")
