extends CanvasLayer

var script_fajl = load("res://scripts/load_datas.gd")
@onready var categorie_box = $potionmenu/Control/VBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == 0):
			print(categorie.parent_id)
			var button = Button.new()
			button.custom_minimum_size = Vector2(79, 105)
			button.add_theme_stylebox_override("normal", preload("res://styles/potioncategoryactive.tres"))
			categorie_box.add_child(button)
			
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fozes() -> void:
	for categorie in PotionCategorie.all_instances:
		print(categorie.name)
