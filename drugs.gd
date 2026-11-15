extends Node2D

@export_file("*.tscn") var next_scene := "res://Main_game.tscn"
@export var fade_time := 1.0  # segundos até ficar tudo preto

var _fade: ColorRect
var _triggered := false


func _ready() -> void:
	# Camada por cima de tudo com um retângulo preto, começa transparente
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.modulate.a = 0.0
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_fade)
	_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	$Area2D.body_entered.connect(_on_pills_body_entered)


func _on_pills_body_entered(body: Node2D) -> void:
	if _triggered or not body is CharacterBody2D:
		return
	_triggered = true
	body.set_physics_process(false)  # o jogador deixa de se mexer durante o fade

	var tween := create_tween()
	tween.tween_property(_fade, "modulate:a", 1.0, fade_time)
	await tween.finished
	get_tree().change_scene_to_file(next_scene)
