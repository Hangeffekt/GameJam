class_name Dialogue

var id: int
var group_id: int
var name: String
var dialogue: String

static var all_instances: Array[Dialogue] = []

func _init(p_id: int, p_group_id: int, p_nev: String, p_dialogue: String):
	self.id = p_id
	self.group_id = p_group_id
	self.name = p_nev
	self.dialogue = p_dialogue
	
	all_instances.append(self)

static func get_by_group(target_group_id: int) -> Array[Dialogue]:
	var filtered: Array[Dialogue] = []
	
	for item in all_instances:
		if item.group_id == target_group_id:
			filtered.append(item)
			
	return filtered
