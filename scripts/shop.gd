extends CanvasLayer

var customer: bool = false

@onready var dialogue_manager: CanvasLayer = $DialogueManager

@onready var timer: Timer = $Timer
var script_fajl = load("res://scripts/load_datas.gd")
@onready var potion_scene = load("res://scenes/potion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	if !customer:
		choose_customer()
	
	
	
func choose_customer() -> void:
	dialogue_manager.visible = false
	$MainView.hide()
	$Bc03.show()
	var random_ido: float = randf_range(2.0, 5.0)
	await get_tree().create_timer(random_ido).timeout
	
	$Bc03.hide()
	$MainView.show()
	customer = true
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_manager.text_key, dialogue_manager.characters_name, dialogue_manager.textcolor )
	
func leave_customer() -> void:
	customer = false
	dialogue_manager.visible = false
	choose_customer()


func _on_potion_pressed() -> void:
	$potion.show()
	dialogue_manager.visible = false

func _on_shop_pressed() -> void:
	$potion.hide()
