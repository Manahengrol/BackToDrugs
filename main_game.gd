extends Node2D

const MENU_SCENE := preload("res://main_menu.tscn")

@export_file("*.tscn") var hit_scene := "res://drugs.tscn"
@export var fade_time := 1.0    # segundos a escurecer
@export var black_time := 0.5   # segundos a ficar tudo preto antes de mudar de cena

var pause_layer: CanvasLayer
var _hit := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and pause_layer == null and not _hit:
		open_menu()


func open_menu() -> void:
	pause_layer = CanvasLayer.new()
	pause_layer.layer = 10
	pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS

	var menu := MENU_SCENE.instantiate()
	menu.in_game = true
	menu.resume_requested.connect(close_menu)

	pause_layer.add_child(menu)
	add_child(pause_layer)
	get_tree().paused = true


func close_menu() -> void:
	pause_layer.queue_free()
	pause_layer = null
	get_tree().paused = false


# Chamado pelas garrafas (projectile.gd) quando acertam no jogador
func player_hit() -> void:
	if _hit:
		return
	_hit = true
	$Player.set_physics_process(false)  # jogador e pai param durante o fade
	$Dad.set_physics_process(false)

	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	var fade := ColorRect.new()
	fade.color = Color.BLACK
	fade.modulate.a = 0.0
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(fade)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, fade_time)
	tween.tween_interval(black_time)
	await tween.finished
	get_tree().change_scene_to_file(hit_scene)
