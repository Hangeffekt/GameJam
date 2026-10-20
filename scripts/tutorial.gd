extends CanvasLayer

@onready var start_dialogue_manager: CanvasLayer = $SartTutorial
@onready var main_dialogue_manager: CanvasLayer = $MainTutorial
@onready var potion_dialogue_manager: CanvasLayer = $PotionTutorial
@onready var moonplate_dialogue_manager: CanvasLayer = $MoonPlateTutorial
@onready var tarrot_dialogue_manager: CanvasLayer = $TarrotTutorial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start() -> void:
	start_dialogue_manager.visible = true
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	start_dialogue_manager.start_dialogue(start_dialogue_manager.text_key, start_dialogue_manager.characters_name, start_dialogue_manager.textcolor )
	await start_dialogue_manager.dialogue_finished
	
func main() -> void:
	main_dialogue_manager.visible = true
	$Control/mainpicture.show()
	#jön a kérdés. hogy működik az alábbi sor úgy, hogy a portré listát már nem adjuk meg neki. Válasz: idk but it works, dont touch it
	main_dialogue_manager.start_dialogue(main_dialogue_manager.text_key, main_dialogue_manager.characters_name, main_dialogue_manager.textcolor )
	await main_dialogue_manager.dialogue_finished
	$Control/mainpicture.hide()
	choose_tutorial(0)
	

func choose_tutorial(button: int) -> void:
	
	
	match button:
		0:
			start()
		1:
			main()


func _on_start_btn_pressed() -> void:
	choose_tutorial(1)
