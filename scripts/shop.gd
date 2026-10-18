extends CanvasLayer

@onready var wizard_dialogue_manager: CanvasLayer = $Wizard_DialogueManager
@onready var cat_dialogue_manager: CanvasLayer = $CatDialogueManager
@onready var placeholdername_dialogue_manager: CanvasLayer = $PLACEHOLDERNAMEDialogueManager
@onready var _2placeholdername_dialogue_manager: CanvasLayer = $"2PLACEHOLDERNAMEDialogueManager"

@onready var door_animation: AnimatedSprite2D = $shop_background/door_animation/AnimatedSprite2D
@onready var timer: Timer = $Timer

var ido: float = 3.0


func _ready() -> void:
	choose_customer(GlobalScript.nextcustomer)
	

#karakterekS
func wizard_customer(dialogue_manager: CanvasLayer) -> void:
	dialogue_manager.visible = true
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor )
	await dialogue_manager.dialogue_finished
	leave_customer(dialogue_manager)

func cat_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/potion.tscn")
	##leave_customer(cat_dialogue_manager)

func PLACEHOLDERNAME_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/rythm_game.tscn")

func PLACEHOLDERNAME2_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/tarot_minigame.tscn")


func leave_customer(dialogue_manager: CanvasLayer) -> void:
	dialogue_manager.visible = false
	GlobalScript.nextcustomer = GlobalScript.nextcustomer + 1
	choose_customer(GlobalScript.nextcustomer)


#egy globalis változóba tárolom hogy melyik számu vásárló jön (itt rendelem hozzá a számhoz a vásárlót ha esetleg késöbb felcserélnénk őket)
func choose_customer(nextcustomer: int) -> void:
	await get_tree().create_timer(ido).timeout
	
	
	match nextcustomer:
		0:
			wizard_customer(wizard_dialogue_manager)
		1:
			cat_customer(cat_dialogue_manager)
		2:
			PLACEHOLDERNAME_customer(placeholdername_dialogue_manager)
		3:
			PLACEHOLDERNAME2_customer(_2placeholdername_dialogue_manager)
