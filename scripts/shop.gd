extends CanvasLayer

@onready var wizard_dialogue_manager: CanvasLayer = $Wizard_DialogueManager
@onready var cat_dialogue_manager: CanvasLayer = $CatDialogueManager

@onready var door_animation: AnimatedSprite2D = $shop_background/door_animation/AnimatedSprite2D
@onready var timer: Timer = $Timer

var ido: float = 3.0


func _ready() -> void:
	choose_customer(GlobalScript.nextcustomer)
	

#vásárlók
func wizard_customer() -> void:
	wizard_dialogue_manager.visible = true
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	wizard_dialogue_manager.start_dialogue(wizard_dialogue_manager.text_key, wizard_dialogue_manager.characters_name, wizard_dialogue_manager.textcolor )
	await wizard_dialogue_manager.dialogue_finished
	leave_customer(wizard_dialogue_manager)

func cat_customer() -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	cat_dialogue_manager.visible = true
	cat_dialogue_manager.start_dialogue(cat_dialogue_manager.text_key, cat_dialogue_manager.characters_name, cat_dialogue_manager.textcolor )
	await cat_dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/potion.tscn")
	##leave_customer(cat_dialogue_manager)

func PLACEHOLDERNAME_customer() -> void:
	pass

func PLACEHOLDERNAME2_customer() -> void:
	pass


func leave_customer(char_dialogue_manager: CanvasLayer) -> void:
	char_dialogue_manager.visible = false
	GlobalScript.nextcustomer = GlobalScript.nextcustomer + 1
	choose_customer(GlobalScript.nextcustomer)


#egy globalis változóba tárolom hogy melyik számu vásárló jön (itt rendelem hozzá a számhoz a vásárlót ha esetleg késöbb felcserélnénk őket)
func choose_customer(nextcustomer: int) -> void:
	await get_tree().create_timer(ido).timeout
	
	
	match nextcustomer:
		0:
			wizard_customer()
		1:
			cat_customer()
		2:
			pass
		3:
			pass
