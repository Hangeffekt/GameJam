extends Control
@onready var animation_player: AnimationPlayer = $Label/AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	SceneTransition.change_scene("res://scenes/menu.tscn")
