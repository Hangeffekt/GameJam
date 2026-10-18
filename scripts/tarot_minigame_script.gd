extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	SceneTransition.quit_game()
