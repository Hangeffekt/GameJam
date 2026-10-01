extends CanvasLayer

var script_fajl = load("res://scripts/load_datas.gd")
@onready var categorie_box = $Control/VBox
@onready var categorie_item_box = $ScrollContainer/GridContainer
var sum_green: int = 0
var sum_red: int = 0
var sum_blue: int = 0
var item_place_1: bool = false
var item_place_id_1: int = 0
var item_place_2: bool = false
var item_place_id_2: int = 0
var item_place_3: bool = false
var item_place_id_3: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var uj_objektum = script_fajl.new()
	uj_objektum._ready()
	set_and_write_values(0,0,0)
	category_buttons(1)
	

func category_buttons(id: int):
	#remove child categories
	for child in categorie_box.get_children():
		child.queue_free()
	
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == 0):
			var button = Button.new()
			if categorie.id == id:
				button.custom_minimum_size = Vector2(79, 105)
				button.add_theme_stylebox_override("normal", preload("res://styles/potioncategoryactive.tres"))
				category_items(id)
			else:
				button.custom_minimum_size = Vector2(59, 105)
				button.add_theme_stylebox_override("normal", preload("res://styles/potionmenuinactive.tres"))
			button.pressed.connect(func(): category_items(categorie.id))
			button.pressed.connect(func(): category_buttons(categorie.id))
			categorie_box.add_child(button)

func category_items(id: int):
	#remove child categories
	for child in categorie_item_box.get_children():
		child.queue_free()
	
	for item in PotionCategorie.all_instances:
		if(item.parent_id == id):
			var control = VBoxContainer.new()
			var button = Button.new()
			#create item button
			button.custom_minimum_size = Vector2(100, 100)
			button.add_theme_stylebox_override("normal", preload("res://styles/menubox.tres"))
			button.pressed.connect(func(): item_choosed(item.id, item.atr1, item.atr2, item.atr3))
			control.add_child(button)
			
			#create labels for values
			var labelgreen = create_labels_for_item(str(item.atr1))
			control.add_child(labelgreen)
			labelgreen = create_labels_for_item(str(item.atr2))
			control.add_child(labelgreen)
			labelgreen = create_labels_for_item(str(item.atr3))
			control.add_child(labelgreen)
			categorie_item_box.add_child(control)

func create_labels_for_item(str: String) -> Label:
	var label = Label.new()
	label.text = str
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color("#000000"))
	
	return label
	
func item_choosed(id: int, atr1: int, atr2: int, atr3: int):
	if !item_place_1:
		item_place_1 = true
		item_place_id_1 = id
		set_and_write_values(atr1, atr2, atr3)
	elif !item_place_2:
		item_place_2 = true
		item_place_id_2 = id
		set_and_write_values(atr1, atr2, atr3)
	elif !item_place_3:
		item_place_3 = true
		item_place_id_3 = id
		set_and_write_values(atr1, atr2, atr3)

func set_and_write_values(atr1: int, atr2: int, atr3: int) -> void:
	sum_red = sum_red + atr1
	sum_green = sum_green + atr2
	sum_blue = sum_blue + atr3
	$points/PanelRed/red.text = set_number(sum_red)
	$points/PanelGreen/green.text = set_number(sum_green)
	$points/PanelBlue/blue.text = set_number(sum_blue)
	
func set_number(num: int) -> String:
	if num == 0:
		return "-"
	return str(num) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
