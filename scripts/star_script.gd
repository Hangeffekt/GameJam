extends Node2D
class_name Star

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var index: int = 0

var phase: int = 0
signal phasesignal(index: int, phase: int)

func _ready() -> void:
	_phasechange()

func advance() -> void:
	if phase < 3:
		phase += 1
		_phasechange()

func _phasechange() -> void:
	match phase:
		0:
			animated_sprite_2d.play("phase_0")
		1:
			animated_sprite_2d.play("phase_1")
		2:
			animated_sprite_2d.play("phase_2")
		_:
			print("szia... ezt az üzenetet te neked nem kellene soha de soha látnod. ha mégis látod akkor gratula mert valamit úgy elbasztál hogy az a valóság szabályait ingatja meg. na mind1 majd javítsd ki ezt a 'star_script.gd'-ben")
	phasesignal.emit(index, phase)

#teszteléshez egy gombal
#func _on_button_pressed() -> void:
	#phase += 1
	#print(phase)
	#_phasechange()
