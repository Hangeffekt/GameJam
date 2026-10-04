extends CanvasLayer

@onready var name_label: Label = $Panel/NameLabel
@onready var text_label: RichTextLabel = $Panel/TextLabel

var actual_dialogue: int = 0
var max_dialogue: int = 0
var dialogues: Array = []

func find_dialogue(dialogue_id: int) -> void:
	dialogues = Dialogue.get_by_group(dialogue_id)
	max_dialogue = dialogues.size()
	
	next_dialogue()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		actual_dialogue = actual_dialogue + 1
		if max_dialogue >= actual_dialogue + 1:
			next_dialogue()
		
		

func next_dialogue() -> void:
	name_label.text = dialogues[actual_dialogue].name
	text_label.text = dialogues[actual_dialogue].dialogue
	
	if max_dialogue <= actual_dialogue + 1:
		$Panel/accept.show()
		$Panel/decline.show()




func _on_decline_pressed() -> void:
	actual_dialogue = 0
	max_dialogue = 0
	dialogues = []
	$Panel/accept.hide()
	$Panel/decline.hide()
	$"..".leave_customer()


func _on_accept_pressed() -> void:
	pass
