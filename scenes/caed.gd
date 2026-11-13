extends AnimatableBody3D

@onready var cardSun: AnimatableBody3D = self

@export var target_x: float = 0.1
@export var target_y: float = 0.1
var is_rotated: bool = true
var move_position: bool = false
var original_position: Vector3

func _ready() -> void:
	# Engedélyezzük, hogy a 3D test fogadja az egérkattintást
	input_ray_pickable = true

func _input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_rotated:
		spin_card()
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		move_card_to_coordinates()

func spin_card() -> void:
	is_rotated = true
	# Létrehozzuk a Tween-t
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animáljuk a kártya Y tengelyes rotációját fokokban
	tween.tween_property(cardSun, "rotation_degrees:y", 180, 1.0)

func move_card_to_coordinates() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Ha még nem mozgott el, az új X és Y koordinátára megyünk
	# A Z-t (mélység) meghagyjuk az eredetiben, hogy ne vesszen el
	var destination = original_position
	
	if not move_position:
		destination.x = target_x
		destination.y = target_y
		move_position = true
	else:
		# Vissza az eredeti helyre
		destination = original_position
		move_position = false

	# Animáljuk a teljes position vektort (ez viszi az X-et és az Y-t egyszerre)
	tween.tween_property(cardSun, "position", destination, 1.0)
