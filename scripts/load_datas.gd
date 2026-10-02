extends Node

# Ebben a tömbben fogjuk tárolni a létrehozott példányokat
var dialogue_list: Array[Dialogue] = []
var potion_categorie_list: Array[PotionCategorie] = []
var potion_variation_list: Array[PotionVariation] = []

func _ready() -> void:
	dialogues("res://assets/files/dialogues.txt")
	potioncategories("res://assets/files/potionitems.txt")
	potionvariations("res://assets/files/potionvariations.txt")
	

func dialogues(fajl_utvonal: String) -> void:
	var fajl = FileAccess.open(fajl_utvonal, FileAccess.READ)
	
	if not fajl:
		print("Hiba: A fájl nem található! ", fajl_utvonal)
		return

	while fajl.get_position() < fajl.get_length():
		var sor_elemei: PackedStringArray = fajl.get_csv_line(",")
		
		if sor_elemei.size() < 3:
			continue
			
		var p_id: int = sor_elemei[0].to_int()
		var p_group_id: int = sor_elemei[1].to_int()
		var p_name: String = sor_elemei[2]
		var p_dialogue: String = sor_elemei[3]
		
		var uj_peldany = Dialogue.new(p_id, p_group_id, p_name, p_dialogue)
		
		dialogue_list.append(uj_peldany)
		
	fajl.close()
	
func potioncategories(fajl_utvonal: String) -> void:
	var fajl = FileAccess.open(fajl_utvonal, FileAccess.READ)
	
	if not fajl:
		print("Hiba: A fájl nem található! ", fajl_utvonal)
		return

	while fajl.get_position() < fajl.get_length():
		var sor_elemei: PackedStringArray = fajl.get_csv_line(";")
		
		if sor_elemei.size() < 1:
			continue
			
		var p_id: int = sor_elemei[0].to_int()
		var p_parent_id: int = sor_elemei[1].to_int()
		var p_name: String = sor_elemei[2]
		var p_picture_name: String = sor_elemei[3]
		var p_atr1: int = sor_elemei[4].to_int()
		var p_atr2: int = sor_elemei[5].to_int()
		var p_atr3: int = sor_elemei[6].to_int()
		var p_selected: bool = false
		if p_id == 1:
			p_selected = true
		
		var uj_peldany = PotionCategorie.new(p_id, p_parent_id,
		p_name,
		p_picture_name,
		p_atr1,
		p_atr2,
		p_atr3,
		p_selected)
		potion_categorie_list.append(uj_peldany)
		
	fajl.close()

func potionvariations(fajl_utvonal: String) -> void:
	var fajl = FileAccess.open(fajl_utvonal, FileAccess.READ)
	
	if not fajl:
		print("Hiba: A fájl nem található! ", fajl_utvonal)
		return

	while fajl.get_position() < fajl.get_length():
		var sor_elemei: PackedStringArray = fajl.get_csv_line(";")
		
		if sor_elemei.size() < 1:
			continue
			
		var p_id: int = sor_elemei[0].to_int()
		var p_relation_1: String = sor_elemei[2]
		var target_number_1: int = sor_elemei[3].to_int()
		var p_relation_2: String = sor_elemei[5]
		var target_number_2: int = sor_elemei[6].to_int()
		var p_relation_3: String = sor_elemei[8]
		var target_number_3: int = sor_elemei[9].to_int()
		
		var uj_peldany = PotionVariation.new(p_id,
		p_relation_1,
		target_number_1,
		p_relation_2,
		target_number_2,
		p_relation_3,
		target_number_3)
		potion_variation_list.append(uj_peldany)
		
	fajl.close()
