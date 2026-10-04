extends CanvasLayer

@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/dialogueText
@onready var name_text: Label = $DialogueBox/ColorRect2/nameText

##FONTOS! a listák hosszának meg kell egyeznie
@export var text_key: Array[String] = []
@export var characters_name: Array[String] = []
@export var textcolor: Array[Color] = []

#miért nem egy dictionary vagy többdimenziód tömb?
#ötlet 1: csak a szöveget tárolom. annak elég egy tömb... de jó lenne neveket is tárolni
#ötlet 2: van szöveg és név. ez még kettő külön tömb. Kezelhető, meg már kész van. nem kell ide más... de mi lenne ha a karakterek szövegei más színnel lenne ábrázolva?
#ötlet 3: most vagy csinálok még1 listát és kézzel lekezelem az egésszet, vagy újra írom az EGÉSZ kódot hogy egy dictionary-vel működjön... 

const time_per_char: float = 0.03

var tween: Tween

var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready() -> void:
	TranslationServer.set_locale(GlobalScript.language)
	dialogue_box.visible = false
	
	#start_dialogue(text_key, characters_name, textcolor)

func start_dialogue(lines: Array[String], CHARname: Array[String], color: Array[Color]):
	#game is paused, kivéve a Dialogue manager
	get_tree().paused = true
	#kiszedem az első elemeket a listából
	textcolor = color
	characters_name = CHARname
	dialogue_lines = lines
	current_line_index = 0
	
	is_dialogue_active = true
	dialogue_box.visible = true
	#frissítem a megjelenített szöveget
	updateLine()

func updateLine():
	#felmerült egy hiba a typewriter funkcióban.
	#A char_count nem a fordított szöveg hosszát kapta meg,
	#hanem a localization kulcs nevének hosszát, ezt a tr() metódussal lehetett megoldani
	dialogue_text.text = tr(dialogue_lines[current_line_index])
	name_text.text = tr(characters_name[current_line_index])
	dialogue_text.self_modulate = textcolor[current_line_index]
	typeWriterEffect()

func _input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return
	if event.is_action_pressed("interact"):
		advance_dialogue()


func advance_dialogue():
	if isTyping():
		skipTyping()
		return
	
	#vége van e a beszélgetésnek ellenörzés, léptetés és frissítés
	if current_line_index < dialogue_lines.size() - 1:
		current_line_index += 1
		updateLine()
		
	else: #kezeljük ha vége van a szövegnek
		get_tree().paused = false
		is_dialogue_active = false
		dialogue_box.visible = false
		
func typeWriterEffect():
	#ha már fut akkor megállítjuk
	if tween and tween.is_valid():
		tween.kill()
		
	dialogue_text.visible_characters = 0
	
	var char_count: int = dialogue_text.text.length()
	print(char_count)
	var realTime: float = char_count * time_per_char
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(dialogue_text, "visible_characters", char_count, realTime)

func skipTyping():
	if tween and tween.is_valid():
		tween.kill()
	dialogue_text.visible_ratio = 1.0

func isTyping() -> bool:
	return tween and tween.is_valid() and dialogue_text.visible_ratio < 1.0
