extends CanvasLayer

var script_fajl = load("res://scripts/load_datas.gd")
@onready var categorie_box = $Control/VBox
@onready var categorie_item_box = $ScrollContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	category_buttons(1)
	

func category_buttons(id: int):
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == 0):
			var button = Button.new()
			if categorie.id == id:
				button.custom_minimum_size = Vector2(79, 105)
				category_items(1)
			else:
				button.custom_minimum_size = Vector2(59, 105)
			button.add_theme_stylebox_override("normal", preload("res://styles/potioncategoryactive.tres"))
			button.pressed.connect(func(): category_items(categorie.id))
			categorie_box.add_child(button)

func category_items(id: int):
	#remove child categories
	for child in categorie_item_box.get_children():
		child.queue_free()
	
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == id):
			var control = VBoxContainer.new()
			var button = Button.new()
			#create item button
			button.custom_minimum_size = Vector2(100, 100)
			button.add_theme_stylebox_override("normal", preload("res://styles/menubox.tres"))
			control.add_child(button)
			
			#create labels for values
			var labelgreen = create_labels_for_item(str(categorie.atr1))
			control.add_child(labelgreen)
			labelgreen = create_labels_for_item(str(categorie.atr2))
			control.add_child(labelgreen)
			labelgreen = create_labels_for_item(str(categorie.atr3))
			control.add_child(labelgreen)
			categorie_item_box.add_child(control)

func create_labels_for_item(str: String) -> Label:
	var label = Label.new()
	label.text = str
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color("#000000"))
	
	return label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
