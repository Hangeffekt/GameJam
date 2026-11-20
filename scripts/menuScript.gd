extends Control

@onready var startB: Button = $Start
@onready var optionsB: Button = $Options
@onready var creditsB: Button = $Credits
@onready var exitB: Button = $Exit
@onready var option_animation_player: AnimationPlayer = $OptionsBackground/OptionAnimationPlayer
@onready var credits_animation_player: AnimationPlayer = $CreditsBackground/CreditsAnimationPlayer

#startB
@export var StartButtonBaseHun: Texture2D
@export var StartButtonBaseEng: Texture2D
@export var StartButtonHoverHun: Texture2D
@export var StartButtonHoverEng: Texture2D
#optionsB
@export var OptionsButtonBaseHun: Texture2D
@export var OptionsButtonBaseEng: Texture2D
@export var OptionsButtonHoverHun: Texture2D
@export var OptionsButtonHoverEng: Texture2D
#creditsB
@export var CreditsButtonBaseHun: Texture2D
@export var CreditsButtonBaseEng: Texture2D
@export var CreditsButtonHoverHun: Texture2D
@export var CreditsButtonHoverEng: Texture2D
#exitB
@export var ExitButtonBaseHun: Texture2D
@export var ExitButtonBaseEng: Texture2D
@export var ExitButtonHoverHun: Texture2D
@export var ExitButtonHoverEng: Texture2D

var isCameraDown = false
@onready var CamAnimation_player: AnimationPlayer = $Camera2D/AnimationPlayer

##hover effekthez
var hover_states: Dictionary = {}

func ButtonIconsLocalization() -> void:
	for button in [startB, optionsB, creditsB, exitB]:
		ApplyButtonIcon(button)

func _ready() -> void:
	#itt meg kell adnom egy alap értéket mert különben mindenhol a key érték neve fog kiíródni
	TranslationServer.set_locale(GlobalScript.language)
	
	hover_states = {
		startB: false,
		optionsB: false,
		creditsB: false,
		exitB: false
	}
	
	for button in hover_states.keys():
		button.mouse_entered.connect(OnButtonHover.bind(button, true))
		button.mouse_exited.connect(OnButtonHover.bind(button, false))
	
	ButtonIconsLocalization()

func OnButtonHover(button: Button, hovered: bool) -> void:
	hover_states[button] = hovered
	ApplyButtonIcon(button)

func ApplyButtonIcon(button: Button) -> void:
	var hovered: bool = hover_states.get(button, false)
	var base_icon: Texture2D
	var hover_icon: Texture2D
	var is_eng: bool = GlobalScript.language == "eng"
	
	match button:
		startB:
			base_icon  = StartButtonBaseEng  if is_eng else StartButtonBaseHun
			hover_icon = StartButtonHoverEng if is_eng else StartButtonHoverHun
		optionsB:
			base_icon  = OptionsButtonBaseEng  if is_eng else OptionsButtonBaseHun
			hover_icon = OptionsButtonHoverEng if is_eng else OptionsButtonHoverHun
		creditsB:
			base_icon  = CreditsButtonBaseEng  if is_eng else CreditsButtonBaseHun
			hover_icon = CreditsButtonHoverEng if is_eng else CreditsButtonHoverHun
		exitB:
			base_icon  = ExitButtonBaseEng  if is_eng else ExitButtonBaseHun
			hover_icon = ExitButtonHoverEng if is_eng else ExitButtonHoverHun
	
	button.icon = hover_icon if hovered else base_icon

##press mouse to start game részhez
func _input(event: InputEvent) -> void:
	if isCameraDown:
		return
	if not event.is_action_pressed("interact"):
		return
	CamAnimation_player.play("slide_down")
	isCameraDown = true

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
	ButtonIconsLocalization()
func _on_eng_button_pressed() -> void:
	GlobalScript.language = "eng"
	TranslationServer.set_locale(GlobalScript.language)
	ButtonIconsLocalization()
