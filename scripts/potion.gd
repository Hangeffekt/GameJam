extends CanvasLayer

var script_fajl = load("res://scripts/load_datas.gd")
@onready var categorie_box = $Control/VBox
@onready var categorie_item_box = $ScrollContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == 0):
			var button = Button.new()
			if categorie.id == 1:
				button.custom_minimum_size = Vector2(79, 105)
				category_items(1)
			else:
				button.custom_minimum_size = Vector2(59, 105)
			button.add_theme_stylebox_override("normal", preload("res://styles/potioncategoryactive.tres"))
			categorie_box.add_child(button)
			
func category_items(id: int):
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == id):
			var control = VBoxContainer.new()
			var button = Button.new()
			#create item button
			button.custom_minimum_size = Vector2(100, 100)
			button.add_theme_stylebox_override("normal", preload("res://styles/menubox.tres"))
			control.add_child(button)
			#create labels for values
			var labelgreen = Label.new()
			labelgreen.text = str(categorie.atr1)
			labelgreen.add_theme_font_size_override("font_size", 24)
			labelgreen.add_theme_color_override("font_color", Color("#000000"))
			control.add_child(labelgreen)
			
			categorie_item_box.add_child(control)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
