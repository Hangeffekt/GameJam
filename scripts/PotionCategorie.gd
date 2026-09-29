class_name PotionCategorie

var id: int
var parent_id: int
var name: String
var picture_name: String
var atr1: int
var atr2: int
var atr3: int
var selected: bool

static var all_instances: Array[PotionCategorie] = []

func _init(p_id: int, p_parent_id: int, p_name: String, p_picture_name: String, p_atr1: int, p_atr2: int, p_atr3: int, p_selected: bool):
	print(p_name)
	self.id = p_id
	self.parent_id = p_parent_id
	self.name = p_name
	self.picture_name = p_picture_name
	self.atr1 = p_atr1
	self.atr2 = p_atr2
	self.atr3 = p_atr3
	self.selected = p_selected
	
	all_instances.append(self)
