class_name PotionVariation

var id: int
var relation_1: String
var target_number_1: int
var relation_2: String
var target_number_2: int
var relation_3: String
var target_number_3: int

static var all_variation_instances: Array[PotionVariation] = []

func _init(p_id: int, p_relation_1: String, p_target_number_1: int, p_relation_2: String, p_target_number_2: int, p_relation_3: String, p_target_number_3: int):
	self.id = p_id
	self.relation_1 = p_relation_1
	self.target_number_1 = p_target_number_1
	self.relation_2 = p_relation_2
	self.target_number_2 = p_target_number_2
	self.relation_3 = p_relation_3
	self.target_number_3 = p_target_number_3
	
	all_variation_instances.append(self)
	
static func choose_random_variation(day : int) -> Array[PotionVariation]:
	var id: int = 0
	if(day == 1):
		id = randi_range(1, 15)
	elif(day == 2):
		id = randi_range(16, 30)
	elif(day == 3):
		id = randi_range(31, 50)
	else:
		id = randi_range(1, 50)
		
	return all_variation_instances.filter(func(value): return value.id == id)
