extends CanvasLayer

@onready var categorie_box = $Control/VBox
@onready var categorie_item_box = $ScrollContainer/GridContainer
@onready var recipe_box = $recipe/GridContainer
@onready var result_box = $result/GridContainer
@onready var tutorialScene: CanvasLayer = $Tutorial
@onready var tutorialBtn: Button = $TutorialButton
@onready var finishButton: Button = $MakePotion
@onready var disableCategoryPanel: Panel = $disableCategories
@onready var category_button_sample: Button = $Control/VBox/testbtn
@onready var progresBarSkull: TextureProgressBar = $recipe/Results/ControlSkull/TextureProgressBarSkull
@onready var maxSignSkull: TextureRect = $recipe/Results/ControlSkull/MaxSign
@onready var progresBarStar: TextureProgressBar = $recipe/Results/ControlStar/TextureProgressBarStar
@onready var maxSignStar: TextureRect = $recipe/Results/ControlStar/MaxSign
@onready var progresBarDiamond: TextureProgressBar = $recipe/Results/ControlDiamond/TextureProgressBarDiamond
@onready var maxSignDiamond: TextureRect = $recipe/Results/ControlDiamond/MaxSign
var sum_green: int = 0
var sum_red: int = 0
var sum_blue: int = 0
var item_place_1: bool = false
var item_place_id_1: int = 0
var item_place_2: bool = false
var item_place_id_2: int = 0
var item_place_3: bool = false
var item_place_id_3: int = 0
var recipe: Array 
var used_items: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene.name == "potion":
		set_and_write_values(0,0,0)
		category_buttons(1)
	
		#get recipe
		recipe = PotionVariation.choose_random_variation(3)
		add_labels_to_recipe("x", "x", "x", recipe_box)
		set_progress_value(progresBarSkull, maxSignSkull, recipe[0].relation_1, 0, recipe[0].target_number_1)
		set_progress_value(progresBarStar, maxSignStar, recipe[0].relation_2, 0, recipe[0].target_number_2)
		set_progress_value(progresBarDiamond, maxSignDiamond, recipe[0].relation_3, 0, recipe[0].target_number_3)
		tutorialScene.visible = false
	

func category_buttons(id: int):
	#remove child categories
	for child in categorie_box.get_children():
		child.queue_free()
	
	for categorie in PotionCategorie.all_instances:
		if(categorie.parent_id == 0):
			var button = Button.new()
			button.add_child(add_bg_to_categorie("potion ui_ingredients list_category frame"))
			button.visible = true
			button.add_to_group("potion_buttons")
			if categorie.id == id:
				button.custom_minimum_size = Vector2(100, 101)
				category_items(id)
			else:
				button.custom_minimum_size = Vector2(92, 101)
			button.pressed.connect(func(): category_items(categorie.id))
			button.pressed.connect(func(): category_buttons(categorie.id))
			
			button.add_child(add_image(categorie.picture_name))
			categorie_box.add_child(button)


func category_items(id: int):
	#remove child categories
	for child in categorie_item_box.get_children():
		child.queue_free()
	#felépítés
	#control
	# -> VBoxContainer ebbe kerül a kép  és 3 változó
	# -> -> TextureRect item gomb
	# -> -> 3 db label
	for item in PotionCategorie.all_instances:
		if(item.parent_id == id):
			var control = VBoxContainer.new()
			#control.add_child(add_bg_to_categorie("potion ui_ingredients list_category frame"))
			control.custom_minimum_size = Vector2(125, 250)
			var button = Button.new()
			button.add_to_group("potion_buttons")
			#create item button
			button.add_child(add_bg_to_categorie("item_bg"))
			button.custom_minimum_size = Vector2(125, 125)
			if(used_items.find(item.id) != -1):
				button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				
			else:
				button.pressed.connect(func(): 
					button.add_child(add_bg_to_categorie("potion ui_ingredients list_used ingredient indicator overlay_02"))
					used_items.append(item.id)
					button.mouse_filter = Control.MOUSE_FILTER_IGNORE
					item_choosed(item.picture_name, item.atr1, item.atr2, item.atr3))
			
			button.add_child(add_image(item.picture_name))
			control.add_child(button)
			
			#create labels for values
			control.add_child(add_container("skull_icon", item.atr1))
			control.add_child(add_container("star_icon", item.atr2))
			control.add_child(add_container("diamond_icon", item.atr3))
			categorie_item_box.add_child(control)

#lista itemhez értékek
func add_container(image_name: String, atr: int) -> HBoxContainer:
	var hBoxContainer = HBoxContainer.new()
	hBoxContainer.add_theme_constant_override("separation", 60)
	var labelgreen = create_labels_for_item(set_number(atr))
	var image = add_bg_to_categorie(image_name)
	image.custom_minimum_size = Vector2i(25, 20)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.set_anchors_preset(Control.PRESET_FULL_RECT)
	hBoxContainer.add_child(image)
	hBoxContainer.add_child(labelgreen)
	return hBoxContainer

#kategoria kép
func add_bg_to_categorie(name: String) -> TextureRect:
	var image = TextureRect.new()
	image.texture = load("res://assets/potion/" + name + ".png")
	image.set_anchors_preset(Control.PRESET_FULL_RECT)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	return image

# lista elemekhez kép
func add_image(name: String) -> MarginContainer:
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	var image = TextureRect.new()
	image.texture = load("res://assets/potion/ingredients/" + name + ".png")
	image.set_anchors_preset(Control.PRESET_FULL_RECT)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	margin.add_child(image)
	return margin

func create_labels_for_item(text: String) -> Label:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color("#000000"))
	
	return label

#if the user choosed an item, set the picture and the values on screen
#and create a button tu remove it
func item_choosed(name: String, atr1: int, atr2: int, atr3: int):
	if !item_place_1:
		item_place_1 = true
		item_place_id_1 = atr1
		$selected_item_box/choosed_items/testbtn.add_child(add_image(name))
	elif !item_place_2:
		item_place_2 = true
		item_place_id_2 = atr2
		$selected_item_box/choosed_items/testbtn2.add_child(add_image(name))
	elif !item_place_3:
		item_place_3 = true
		item_place_id_3 = atr3
		$selected_item_box/choosed_items/testbtn3.add_child(add_image(name))
	
	set_and_write_values(atr1, atr2, atr3)
	#progresBarSkull.value += atr1
	countProgressBarResult(progresBarSkull, atr1, recipe[0].relation_1, recipe[0].target_number_1)
	#progresBarStar.value += atr2
	countProgressBarResult(progresBarStar, atr2, recipe[0].relation_2, recipe[0].target_number_2)
	#progresBarDiamond.value += atr3
	countProgressBarResult(progresBarDiamond, atr3, recipe[0].relation_3, recipe[0].target_number_3)
	
	if item_place_1 and item_place_2 and item_place_3:
		finishButton.disabled = false
		disableCategoryPanel.visible = true
		finishButton.add_theme_stylebox_override("normal", preload("res://styles/menubox.tres"))
		

func countProgressBarResult(bar: TextureProgressBar, atr: int, relacio: String, target: int) -> void:
	if target > 0:
		bar.value += atr
	elif target < 0:
		bar.value += (atr * -1)
	elif target == 0 and relacio == '>':
		bar.value += atr
	elif target == 0 and relacio == '<':
		bar.value += (atr * -1)
	else:
		print("megy")
		if bar.value > 2 and atr > 0:
			bar.value += (atr * -1)
		elif bar.value > 2 and atr < 0:
			bar.value += atr
		elif bar.value <= 2:
			bar.value += (atr * -1)
	
	
func set_and_write_values(atr1: int, atr2: int, atr3: int) -> void:
	sum_red = sum_red + atr1
	sum_green = sum_green + atr2
	sum_blue = sum_blue + atr3
	$points/PanelRed/red.text = set_number(sum_red)
	$points/PanelGreen/green.text = set_number(sum_green)
	$points/PanelBlue/blue.text = set_number(sum_blue)

#choosed item end
	
func set_number(num: int) -> String:
	if num == 0:
		return "-"
	return str(num) 

#write the recipe on screen
func add_labels_to_recipe(str1: String, str2: String, str3: String, placeholder) -> void:
	create_and_set_new_label(str1, placeholder)
	create_and_set_new_label(recipe[0].relation_1, placeholder)
	create_and_set_new_label(str(recipe[0].target_number_1), placeholder)
	create_and_set_new_label(str2, placeholder)
	create_and_set_new_label(recipe[0].relation_2, placeholder)
	create_and_set_new_label(str(recipe[0].target_number_2), placeholder)
	create_and_set_new_label(str3, placeholder)
	create_and_set_new_label(recipe[0].relation_3, placeholder)
	create_and_set_new_label(str(recipe[0].target_number_3), placeholder)

func create_and_set_new_label(str_value: String, placeholder) -> void:
	var text_label = Label.new()
	text_label.add_theme_font_size_override("font_size", 35)
	text_label.add_theme_color_override("font_color", Color("#000000"))
	text_label.text = str_value
	placeholder.add_child(text_label)
	
func mini_game_result(left_side: int, relation: String, right_side: int) -> int:
	var line_result = false
	if(relation == ">"):
		line_result = left_side > right_side
	elif(relation == "<"):
		line_result = left_side < right_side
	elif(relation == "-"):
		line_result = left_side == 0
	
	if line_result:
		return 1
	else:
		return 0
		
func end_game(atr1: int, atr2: int, atr3: int) -> void:
	#disable mouse and scroll
	for button in get_tree().get_nodes_in_group("potion_buttons"):
		if button is Button:
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$ScrollContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	#set and write game result
	add_labels_to_recipe(set_number(sum_red), set_number(sum_green), set_number(sum_blue), result_box)
	var result_point = 0
	result_point = result_point + mini_game_result(sum_red, recipe[0].relation_1, recipe[0].target_number_1)
	result_point = result_point + mini_game_result(sum_green, recipe[0].relation_2, recipe[0].target_number_2)
	result_point = result_point + mini_game_result(sum_blue, recipe[0].relation_3, recipe[0].target_number_3)
	
	match(result_point):
		0:
			$result/textResult.text = "Rossz"
		1:
			$result/textResult.text = "Rossz"
		2:
			$result/textResult.text = "Jó"
		3:
			$result/textResult.text = "Kiváló"
	$result.show()
	await get_tree().create_timer(5.0).timeout
	GlobalScript.nextcustomer = GlobalScript.nextcustomer + 1
	SceneTransition.change_scene("res://scenes/shop.tscn")

#ha pozitív nincs dolog
#ha negatív vesszük a maximum abszolut értékét
# ha 0 a maximum 3 és azon az értéken áll 
func set_progress_value(texture_progress_bar: TextureProgressBar, maxSign: TextureRect, relacio:String, value: float, max_limit: float):
	
	maxSign.position.x = 128/(abs(max_limit)+2)*abs(max_limit+1)
	maxSign.position.y = -3.0
	if max_limit > 0:
		texture_progress_bar.min_value = 0
		texture_progress_bar.max_value = max_limit + 1
		texture_progress_bar.value = 0.0
		return
	elif max_limit < 0:
		texture_progress_bar.min_value = 0
		texture_progress_bar.max_value = abs(max_limit) + 1
		texture_progress_bar.value = 0
		return
	elif max_limit == 0 and relacio != '-':
		maxSign.position.x = 128/2*1
		texture_progress_bar.min_value = 0
		texture_progress_bar.max_value = 1
		texture_progress_bar.value = 0
	else:
		maxSign.position.x = 128/2*1
		texture_progress_bar.min_value = 0
		texture_progress_bar.max_value = 2.0
		texture_progress_bar.value = 2.0
	
func _on_tutorial_button_pressed() -> void:
	tutorialBtn.visible = false
	tutorialScene.visible = true
	tutorialScene.choose_tutorial(2)

# jéték befejezése
func _on_make_potion_pressed() -> void:
	end_game(item_place_id_1, item_place_id_2, item_place_id_3)
