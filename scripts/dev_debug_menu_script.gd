extends Control
@onready var panel: Panel = $Panel

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("Debug_menu"):
		return
	else:
		if panel.visible:
			panel.visible = false
		else:
			panel.visible = true

func _on_menu_scene_pressed() -> void:
	SceneTransition.change_scene("res://scenes/menu.tscn")


func _on_shop_scene_pressed() -> void:
	SceneTransition.change_scene("res://scenes/shop.tscn")


func _on_rythm_scene_pressed() -> void:
	SceneTransition.change_scene("res://scenes/rythm_game.tscn")


func _on_potion_scene_pressed() -> void:
	SceneTransition.change_scene("res://scenes/potion.tscn")

func _on_tarot_pressed() -> void:
	SceneTransition.change_scene("res://scenes/tarrot.tscn")


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#eng
func _on_button_pressed() -> void:
	GlobalScript.language = "eng"
	TranslationServer.set_locale(GlobalScript.language)

#hu
func _on_button_2_pressed() -> void:
	GlobalScript.language = "hun"
	TranslationServer.set_locale(GlobalScript.language)
