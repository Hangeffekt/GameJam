extends Control
@onready var panel: Panel = $Panel


func _on_menu_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_shop_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")


func _on_rythm_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rythm_game.tscn")


func _on_potion_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rythm_game.tscn")


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


func _on_debug_visible_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel.visible = true
	else: panel.visible = false	
