extends Node2D

signal resume_requested

var in_game := false

func _input(event: InputEvent) -> void:
	
	if in_game and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() 
		resume_requested.emit()

func _on_start_pressed() -> void:
	if in_game:
		resume_requested.emit() 
	else:
		get_tree().change_scene_to_file("res://Main_game.tscn")


func _on_credits_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://credits.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()
