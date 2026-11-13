extends CanvasLayer

@onready var wizard_dialogue_manager: CanvasLayer = $Wizard_DialogueManager
@onready var cat_dialogue_manager: CanvasLayer = $CatDialogueManager
@onready var monster_hunter_dialogue_manager: CanvasLayer = $MonsterHunterDialogueManager
@onready var _2placeholdername_dialogue_manager: CanvasLayer = $"2PLACEHOLDERNAMEDialogueManager"

@onready var door_animation: AnimatedSprite2D = $shop_background/door_animation/AnimatedSprite2D
@onready var timer: Timer = Timer.new()

##potion minigame utáni lehetőségek
@onready var perfect_potion: CanvasLayer = $perfect_potion
@onready var bad_potion: CanvasLayer = $Bad_potion
@onready var good_potion: CanvasLayer = $Good_potion
##tarot minigame után
@onready var tarot_good: CanvasLayer = $Tarot_good
@onready var tarot_bad: CanvasLayer = $Tarot_bad


var ido: float = 3.0

func _ready() -> void:
	choose_customer(GlobalScript.nextcustomer)

##karakterek
func wizard_customer(dialogue_manager: CanvasLayer) -> void:
	dialogue_manager.visible = true
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor, false )
	await dialogue_manager.dialogue_finished
	leave_customer(dialogue_manager)

func cat_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor, false )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/potion.tscn")

#különböző elágazásokhoz használt dialógus metódus. pl: potion grade reakciók vagy tartot positiv negativ válasz
func different_ending(dialogue_manager: CanvasLayer) -> void:
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor, false )
	await dialogue_manager.dialogue_finished
	leave_customer(dialogue_manager)

func MonsterHunter_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor, false )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/rythm_game.tscn")


func PLACEHOLDERNAME2_customer(dialogue_manager: CanvasLayer) -> void:
	door_animation.play("open")
	await door_animation.animation_finished
	
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor, false )
	await dialogue_manager.dialogue_finished
	SceneTransition.change_scene("res://scenes/tarrot.tscn")


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
			match GlobalScript.potiongrade:
				"Kiváló":
					different_ending(perfect_potion)
				"Jó":
					different_ending(good_potion)
				"Rossz":
					different_ending(bad_potion)
		3:
			MonsterHunter_customer(monster_hunter_dialogue_manager)
		4:
			match GlobalScript.tarotgarde:
				"positive":
					different_ending(tarot_good)
				"negative":
					different_ending(tarot_bad)
		5:
			PLACEHOLDERNAME2_customer(_2placeholdername_dialogue_manager)
