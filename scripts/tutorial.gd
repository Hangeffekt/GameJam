extends CanvasLayer

@onready var start_dialogue_manager: CanvasLayer = $SartTutorial
@onready var main_dialogue_manager: CanvasLayer = $MainTutorial
@onready var potion_dialogue_manager: CanvasLayer = $PotionTutorial
@onready var moonplate_dialogue_manager: CanvasLayer = $MoonPlateTutorial
@onready var tarrot_dialogue_manager: CanvasLayer = $TarrotTutorial
@onready var still_here_manager: CanvasLayer = $StillHere

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start() -> void:
	start_dialogue_manager.visible = true
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	start_dialogue_manager.start_dialogue(start_dialogue_manager.text_key, start_dialogue_manager.characters_name, start_dialogue_manager.textcolor,false )
	await start_dialogue_manager.dialogue_finished
	
func main() -> void:
	main_dialogue_manager.visible = true
	main_dialogue_manager.show()
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	main_dialogue_manager.start_dialogue(main_dialogue_manager.text_key, main_dialogue_manager.characters_name, main_dialogue_manager.textcolor,true  )
	await main_dialogue_manager.dialogue_finished
	main_dialogue_manager.hide()
	choose_tutorial(5)

func potion() -> void:
	potion_dialogue_manager.visible = true
	potion_dialogue_manager.show()
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	potion_dialogue_manager.start_dialogue(potion_dialogue_manager.text_key, potion_dialogue_manager.characters_name, potion_dialogue_manager.textcolor,true  )
	await potion_dialogue_manager.dialogue_finished
	potion_dialogue_manager.hide()
	choose_tutorial(5)

func moonplate() -> void:
	moonplate_dialogue_manager.visible = true
	moonplate_dialogue_manager.show()
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	moonplate_dialogue_manager.start_dialogue(moonplate_dialogue_manager.text_key, moonplate_dialogue_manager.characters_name, moonplate_dialogue_manager.textcolor,true  )
	await moonplate_dialogue_manager.dialogue_finished
	moonplate_dialogue_manager.hide()
	choose_tutorial(5)


func still_here() -> void:
	still_here_manager.visible = true
	still_here_manager.show()
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	still_here_manager.start_dialogue(still_here_manager.text_key, still_here_manager.characters_name, still_here_manager.textcolor,false  )
	await still_here_manager.dialogue_finished

func choose_tutorial(button: int) -> void:
	match button:
		0:
			start()
		1:
			main()
		2:
			potion()
		3:
			moonplate()
		4:
			moonplate()
		5:
			still_here()


func _on_start_btn_pressed() -> void:
	choose_tutorial(1)


func _on_potion_btn_pressed() -> void:
	choose_tutorial(2)


func _on_moon_plate_btn_pressed() -> void:
	choose_tutorial(3)

#close tutorial
func _on_tutorial_button_pressed() -> void:
	$".".visible = false
