extends Node3D
@export var speed: float = 5.0
@onready var cardTop = $cardTop
@onready var cardSun = $cardSun
@onready var cardHermit = $cardHermit
@onready var cardCups = $cardCups
@onready var goodBtn: Button = $CanvasLayer/Good
@onready var badBtn: Button = $CanvasLayer/Bad
@export var target_x: float = 0.45
@export var target_y: float = 0.415

#dialogues
@onready var CupGood = $CanvasLayer/CupGood
@onready var CupBad = $CanvasLayer/CupBad
@onready var HermitGood = $CanvasLayer/HermitGood
@onready var HermitBad = $CanvasLayer/HermitBad
@onready var SunGood = $CanvasLayer/SunGood
@onready var SunBad = $CanvasLayer/SunBad

var sun_is_rotated: bool = false
var hermit_is_rotated: bool = false
var cups_is_rotated: bool = false
var move_position: bool = false
var card_block: bool = false # ha egy kártya fent van akkor ne lehessen másikra kattintani
var sun_original_position: Vector3
var hermit_original_position: Vector3
var cups_original_position: Vector3
var global_card: String
var result: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Engedélyezzük, hogy a 3D test fogadja az egérkattintást
	cardSun.input_ray_pickable = true
	cardHermit.input_ray_pickable = true
	cardCups.input_ray_pickable = true
	cardTop.input_ray_pickable = true
	
	goodBtn.pressed.connect(_on_good_pressed)
	badBtn.pressed.connect(_on_bad_pressed)

func move_card_to_coordinates() -> void:
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Ha még nem mozgott el, az új X és Y koordinátára megyünk
	# A Z-t (mélység) meghagyjuk az eredetiben, hogy ne vesszen el
	var hermit_destination = hermit_original_position
	var sun_destination = sun_original_position
	var cups_destination = cups_original_position
	
	if not move_position:
		hermit_destination.x += 0.0
		hermit_destination.y += target_y + 0.25
		sun_destination.x += target_x
		sun_destination.y += target_y
		cups_destination.x += -target_x
		cups_destination.y += target_y
		move_position = true
	else:
		# Vissza az eredeti helyre
		hermit_destination = hermit_original_position
		move_position = false

	# Animáljuk a teljes position vektort (ez viszi az X-et és az Y-t egyszerre)
	tween.tween_property(cardHermit, "position", hermit_destination, 1.0)
	tween.tween_property(cardSun, "position", sun_destination, 1.0)
	tween.tween_property(cardCups, "position", cups_destination, 1.0)
	
	sun_is_rotated = true
	hermit_is_rotated = true
	cups_is_rotated = true

func _on_area_3d_input_event_cardTop(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not move_position:
		move_card_to_coordinates()

func flip_card(card: String) -> void:
	# Létrehozzuk a Tween-t
	card_block = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if card == "sun":
		tween.tween_property(cardSun, "rotation_degrees:y", 180.0, 0.6)
		tween.tween_property(cardSun, "position:z", cardSun.position.z + 0.35, 1.0)
		goodBtn.text = "TAROT_TITLE_SUN_G"
		badBtn.text = "TAROT_TITLE_SUN_B"
		sun_is_rotated = false
		
	elif card == "hermit":
		tween.tween_property(cardHermit, "rotation_degrees:y", 180, 0.6)
		tween.parallel().tween_property(cardHermit, "position:z", cardHermit.position.z + 0.35, 1.0)
		tween.parallel().tween_property(cardHermit, "position:y", cardHermit.position.y - 0.25, 1.0)
		goodBtn.text = "TAROT_TITLE_HERMIT_G"
		badBtn.text = "TAROT_TITLE_HERMIT_B"
		hermit_is_rotated = false
		
	elif card == "cups":
		tween.tween_property(cardCups, "rotation_degrees:y", 180, 0.6)
		tween.tween_property(cardCups, "position:z", cardCups.position.z + 0.35, 1.0)
		goodBtn.text = "TAROT_TITLE_CUPS_G"
		badBtn.text = "TAROT_TITLE_CUPS_B"
		cups_is_rotated = false
	
	global_card = card
	await get_tree().create_timer(1.5).timeout
	goodBtn.visible = true
	badBtn.visible = true

func flip_card_back(card: String) -> void:
	global_card = ""
	# Létrehozzuk a Tween-t
	card_block = false
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if card == "sun":
		tween.tween_property(cardSun, "position:z", cardSun.position.z - 0.35, 1.0)
		
	elif card == "hermit":
		tween.parallel().tween_property(cardHermit, "position:z", cardHermit.position.z - 0.35, 1.0)
		tween.parallel().tween_property(cardHermit, "position:y", cardHermit.position.y + 0.25, 1.0)
		
	elif card == "cups":
		tween.tween_property(cardCups, "position:z", cardCups.position.z - 0.35, 1.0)
	
	if not sun_is_rotated and not hermit_is_rotated and not cups_is_rotated:
		_on_change_sceene()

func _on_change_sceene() -> void:
	if result <= 2:
		GlobalScript.tarotgarde = "positive"
	else:
		GlobalScript.tarotgarde = "negative"
		
	GlobalScript.nextcustomer = GlobalScript.nextcustomer + 1
	SceneTransition.change_scene("res://scenes/shop.tscn")

func _on_area_3d_input_event_sunCard(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and sun_is_rotated and not card_block:
		flip_card("sun")
		

func _on_area_3d_input_event_cardHermit(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and hermit_is_rotated and not card_block:
		flip_card("hermit")
		

func _on_area_3d_input_event_cardCups(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and cups_is_rotated and not card_block:
		flip_card("cups")

#good and bad button functions
func _on_good_pressed() -> void:
	goodBtn.visible = false
	badBtn.visible = false
	
	if global_card == "cups":
		CupGood.visible = true
		CupGood.start_dialogue(CupGood.text_key, CupGood.characters_name, CupGood.textcolor, false )
		await CupGood.dialogue_finished
	elif global_card == "hermit":
		HermitGood.visible = true
		HermitGood.start_dialogue(HermitGood.text_key, HermitGood.characters_name, HermitGood.textcolor, false )
		await HermitGood.dialogue_finished
	elif global_card == "sun":
		SunGood.visible = true
		SunGood.start_dialogue(SunGood.text_key, SunGood.characters_name, SunGood.textcolor, false )
		await SunGood.dialogue_finished
	
	result += 1
	await get_tree().create_timer(0.5).timeout
	flip_card_back(global_card)
	
func _on_bad_pressed() -> void:
	goodBtn.visible = false
	badBtn.visible = false
	
	if global_card == "cups":
		CupBad.visible = true
		CupBad.start_dialogue(CupBad.text_key, CupBad.characters_name, CupBad.textcolor, false )
		await CupBad.dialogue_finished
	elif global_card == "hermit":
		HermitBad.visible = true
		HermitBad.start_dialogue(HermitBad.text_key, HermitBad.characters_name, HermitBad.textcolor, false )
		await HermitBad.dialogue_finished
	elif global_card == "sun":
		SunBad.visible = true
		SunBad.start_dialogue(SunBad.text_key, SunBad.characters_name, SunBad.textcolor, false )
		await SunBad.dialogue_finished
	
	await get_tree().create_timer(0.5).timeout
	flip_card_back(global_card)
