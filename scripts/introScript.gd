extends Control

@onready var intro_dialogue: CanvasLayer = $"Intro dialogue"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_dialogue.visible = true
	await SceneTransition.transitionFin
	
	intro_dialogue.start_dialogue(intro_dialogue.text_key, intro_dialogue.characters_name, intro_dialogue.textcolor, false )
	await intro_dialogue.dialogue_finished
	SceneTransition.change_scene("res://scenes/shop.tscn")
