extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	SceneTransition.change_scene("res://scenes/menu.tscn")
	
