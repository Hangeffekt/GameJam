class_name PotionCategorie

var id: int
var name: String
var selected: bool

static var all_instances: Array[PotionCategorie] = []

func _init(p_id: int, p_name: String, p_selected: bool):
	print(p_name)
	self.id = p_id
	self.name = p_name
	self.selected = p_selected
	
	all_instances.append(self)
