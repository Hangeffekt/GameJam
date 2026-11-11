extends Node3D
@export var speed: float = 5.0
@onready var cardTop = $cardTop
@onready var cardSun = $cardSun
@onready var cardHermit = $cardHermit
@onready var cardCups = $cardCups
@export var target_x: float = 0.5
@export var target_y: float = 0.5

var sun_is_rotated: bool = false
var hermit_is_rotated: bool = false
var cups_is_rotated: bool = false
var move_position: bool = false
var sun_original_position: Vector3
var hermit_original_position: Vector3
var cups_original_position: Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Engedélyezzük, hogy a 3D test fogadja az egérkattintást
	cardSun.input_ray_pickable = true
	cardHermit.input_ray_pickable = true
	cardCups.input_ray_pickable = true
	cardTop.input_ray_pickable = true

func move_card_to_coordinates() -> void:
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Ha még nem mozgott el, az új X és Y koordinátára megyünk
	# A Z-t (mélység) meghagyjuk az eredetiben, hogy ne vesszen el
	var hermit_destination = hermit_original_position
	var sun_destination = sun_original_position
	var cups_destination = cups_original_position
	
	if not move_position:
		hermit_destination.x += 0.0
		hermit_destination.y += target_y + 0.1
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


func _on_area_3d_input_event_sunCard(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and sun_is_rotated:
		# Létrehozzuk a Tween-t
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Animáljuk a kártya Y tengelyes rotációját fokokban
		tween.tween_property(cardSun, "rotation_degrees:y", 180, 1.0)
		sun_is_rotated = false


func _on_area_3d_input_event_cardHermit(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and hermit_is_rotated:
		# Létrehozzuk a Tween-t
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Animáljuk a kártya Y tengelyes rotációját fokokban
		tween.tween_property(cardHermit, "rotation_degrees:y", 180, 1.0)
		hermit_is_rotated = false


func _on_area_3d_input_event_cardCups(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and cups_is_rotated:
		# Létrehozzuk a Tween-t
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Animáljuk a kártya Y tengelyes rotációját fokokban
		tween.tween_property(cardCups, "rotation_degrees:y", 180, 1.0)
		cups_is_rotated = false
