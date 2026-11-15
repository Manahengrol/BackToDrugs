extends Node
# Called when the node enters the scene tree for the first time.
var vida = 5

func _ready():
	$Label.text = "clica no espaco 5 vezes"
	
func _input(event):
	if event.is_action_pressed("my_action"):
		
		if vida >= 1:
			$Label.text = "vida: %d" % vida
			vida -= 1
	
		else:
			$Label.text = "és um amor"
