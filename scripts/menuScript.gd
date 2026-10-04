extends Control

@onready var startB: Button = $Menu_VBoxContainer/Start
@onready var optionsB: Button = $Menu_VBoxContainer/Options
@onready var creditsB: Button = $Menu_VBoxContainer/Credits
@onready var exitB: Button = $Menu_VBoxContainer/Exit
@onready var options_background: Panel = $OptionsBackground
@onready var credits_background: Panel = $CreditsBackground

func _ready() -> void:
	#itt meg kell adnom egy alap értéket mert különben mindenhol a key érték neve fog kiíródni
	TranslationServer.set_locale(GlobalScript.language)
	

##Button Singals
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func _on_options_pressed() -> void:
	options_background.visible = true
	credits_background.visible = false

func _on_credits_pressed() -> void:
	credits_background.visible = true
	options_background.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()


##options menu
func _on_option_exit_button_pressed() -> void:
	options_background.visible = false

#nyelv váltás
func _on_hun_button_pressed() -> void:
	GlobalScript.language = "hun"
	TranslationServer.set_locale(GlobalScript.language)
func _on_eng_button_pressed() -> void:
	GlobalScript.language = "eng"
	TranslationServer.set_locale(GlobalScript.language)

#fullscreen/windowed váltás
func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


##Credits menu
func _on_credits_exit_button_pressed() -> void:
	credits_background.visible = false
