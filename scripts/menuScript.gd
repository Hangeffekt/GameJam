extends Control

@onready var startB: Button = $Start
@onready var optionsB: Button = $Options
@onready var creditsB: Button = $Credits
@onready var exitB: Button = $Exit
@onready var option_animation_player: AnimationPlayer = $OptionsBackground/OptionAnimationPlayer
@onready var credits_animation_player: AnimationPlayer = $CreditsBackground/CreditsAnimationPlayer


func _ready() -> void:
	#itt meg kell adnom egy alap értéket mert különben mindenhol a key érték neve fog kiíródni
	TranslationServer.set_locale(GlobalScript.language)
	

##Button Singals
func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/shop.tscn")
	

func _on_options_pressed() -> void:
	creditsB.disabled = true
	option_animation_player.play("show")

func _on_credits_pressed() -> void:
	optionsB.disabled = true
	credits_animation_player.play("show")

func _on_exit_pressed() -> void:
	SceneTransition.quit_game()


##options menu
func _on_option_exit_button_pressed() -> void:
	creditsB.disabled = false
	option_animation_player.play_backwards("show")

##Credits menu
func _on_credits_exit_button_pressed() -> void:
	optionsB.disabled = false
	credits_animation_player.play_backwards("show")

##nyelv váltás
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
