extends Node2D

@onready var wave: Node2D = $wave
@onready var animation_player: AnimationPlayer = $wave/Sprite2D/AnimationPlayer
@onready var test: Label = $test
@onready var wave_area_2d: Area2D = $wave/Sprite2D/wave_Area2D
@onready var leesett_jelzo: Area2D = $szelle_jelzok/leesett_jelzo
@onready var perfect_szelle_jelzo: Area2D = $szelle_jelzok/perfect_szelle_jelzo
@onready var good_szelle_jelzo: Area2D = $szelle_jelzok/good_szelle_jelzo
@onready var early_szelle_jelzo: Area2D = $szelle_jelzok/early_szelle_jelzo
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var victory_label: Label = $"ProgressBar/victory label"

@onready var stars_collection: Node2D = $stars_collection
@onready var stars: Array[Star] = []
#ezzel figyelem melyik csillagnál járunk
var cursor = 0

# felmerült egy hiba ahol ha a játékos spamelte az interact inputot, akkor töbször kapott pontot az "1 pont / hullám" helyett. 
# ezért egy sima ellenörzés miatt csináltam ezt a változót. ami lehetne bool is de idgaf
var antispam = 1
var points = 0
const maxpoints = 20

#amikor a csepp leesik akkor csinál egy hullámot
func _on_leesett_jelzo_area_entered(area: Area2D) -> void:
	if area.name == "dropplet_area":
		wave.visible = true
		animation_player.play("waweing")
		test.text = " "
		antispam = 1

#igen minden egyes inputnál megnézzük még akkor is ha a játékos megmozgatta az egért,
# mert az alap godot generált inputokat nem lenne okos dolog kitörölni
func _input(event: InputEvent) -> void:
	if antispam == 0:
		return
	
	#itt nézzük meg hogy hol van a hullám amikor a felhasználó megnyomja az egér gombot
	if not event.is_action_pressed("interact"):
		return
	else:
		antispam = 0
		
	if wave_area_2d.overlaps_area(perfect_szelle_jelzo):
		test.text = "PERFECT"
		points += 2
		pontszerzes(2)
		animation_player.play("idle")
		
	if wave_area_2d.overlaps_area(good_szelle_jelzo):
		test.text = "GOOD"
		points += 1
		pontszerzes(1)
		animation_player.play("idle")
	if wave_area_2d.overlaps_area(early_szelle_jelzo):
		test.text = "EARLY"
		animation_player.play("idle")

##GET READY FOR THE STARS
func _ready() -> void:
	#összegyüjtöm a sok csillag objektumot a stars listába
	for child in stars_collection.get_children():
		if child is Star:                 
			stars.append(child)
	
	for star in stars:
		star.phasesignal.connect(_on_phasesignal)
		
func pontszerzes(value: int) -> void:
	while value > 0 and cursor < stars.size():
		stars[cursor].advance()
		value -= 1
		if stars[cursor].phase >= 2:
			cursor += 1
			progress_bar.value = points
	if cursor >= stars.size():
		print("minden csillag maxon van1")

func  _on_phasesignal(index: int, phase: int) -> void:
	print("Star ", index, " phase: ", phase)


func _on_progress_bar_value_changed(value: float) -> void:
	if value == maxpoints:
		victory_label.visible = true
