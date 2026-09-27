extends CanvasLayer
var customer: bool = false

@onready var timer: Timer = $Timer
var script_fajl = load("res://scripts/load_datas.gd")
@onready var potion_scene = load("res://scenes/potion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	if !customer:
		choose_customer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if customer:
		$DialogueBox.show()
	
func choose_customer() -> void:
	$DialogueBox.hide()
	$MainView.hide()
	$Bc03.show()
	var random_ido: float = randf_range(2.0, 5.0)
	await get_tree().create_timer(random_ido).timeout
	
	$Bc03.hide()
	$MainView.show()
	$DialogueBox.find_dialogue(2)
	customer = true
	
func leave_customer() -> void:
	customer = false
	choose_customer()


func _on_potion_pressed() -> void:
	$potion.show()
	$DialogueBox.hide()

func _on_shop_pressed() -> void:
	$potion.hide()
