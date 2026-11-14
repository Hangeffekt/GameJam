extends CanvasLayer

@onready var color_rect_2: ColorRect = $DialogueBox/ColorRect2
@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/dialogueText
@onready var name_text: Label = $DialogueBox/ColorRect2/nameText
@onready var portrait: TextureRect = $Portrait
@onready var tutorialportrait: TextureRect = $TutorialPortrait
signal dialogue_finished
var isTutorial: bool = false

##FONTOS! a listák hosszának meg kell egyeznie
@export var text_key: Array[String] = []
@export var characters_name: Array[String] = []
@export var textcolor: Array[Color] = []
@export var Portraits: Array[Texture2D] = []
@export var TutorialScreens: Array[Texture2D] = []

#miért nem egy dictionary vagy többdimenziód tömb?
#ötlet 1: csak a szöveget tárolom. annak elég egy tömb... de jó lenne neveket is tárolni
#ötlet 2: van szöveg és név. ez még kettő külön tömb. Kezelhető, meg már kész van. nem kell ide más... de mi lenne ha a karakterek szövegei más színnel lenne ábrázolva?
#ötlet 3: most vagy csinálok még1 listát és kézzel lekezelem az egésszet, vagy újra írom az EGÉSZ kódot hogy egy dictionary-vel működjön... 

##belépő animáció
const PortreEntraceDuration: float = 0.7
const PortraitStartScale: float = 0.7
const PortraitStartOffsetY: float = -40.0
const PortraitSiruetteHold: float = 0.35 #meddig marad teljesen fekete
const PortraitFadeDuration: float = 0.45 #sziruett eltünésének hossza

var currentPortrait: Texture2D = null
var PortreEntraceTween: Tween
var PortraitHomePos: Vector2
var PortraitHomeScale: Vector2
var PortraitHomeModulate: Color = Color.WHITE
var PortraitHomeReady: bool = false

@export var entraceAnimIndexes: Array[int] = []


const time_per_char: float = 0.03

var tween: Tween

var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready() -> void:
	TranslationServer.set_locale(GlobalScript.language)
	dialogue_box.visible = false
	Capture_portrait_home.call_deferred()
	
func Capture_portrait_home() -> void:
	await get_tree().process_frame
	PortraitHomePos = portrait.position
	PortraitHomeScale = portrait.scale
	PortraitHomeModulate = portrait.modulate
	PortraitHomeReady = true
	
func PlayPortraitEntrace(target: TextureRect) -> void:
	if PortreEntraceTween and PortreEntraceTween.is_valid():
		PortreEntraceTween.kill()
		
	if not PortraitHomeReady:
		PortraitHomePos = portrait.position
		PortraitHomeScale = portrait.scale
		PortraitHomeModulate = portrait.modulate
		PortraitHomeReady = true
		
	target.pivot_offset = target.size * 0.5
	
	target.position = PortraitHomePos + Vector2(0, PortraitStartOffsetY)
	target.scale = PortraitHomeScale * PortraitStartScale
	target.modulate = Color(0,0,0, PortraitHomeModulate.a)
	
	
	##tweens
	PortreEntraceTween = create_tween()
	PortreEntraceTween.set_parallel(true)
	PortreEntraceTween.set_trans(Tween.TRANS_CUBIC)
	PortreEntraceTween.set_ease(Tween.EASE_OUT)
	
	#csúszás
	PortreEntraceTween.tween_property(target, "position", PortraitHomePos, PortreEntraceDuration)
	#növekvés
	PortreEntraceTween.tween_property(target, "scale", PortraitHomeScale, PortreEntraceDuration)
	#sziluett
	PortreEntraceTween.tween_property(target, "modulate", PortraitHomeModulate, PortraitFadeDuration).set_delay(PortraitSiruetteHold).set_trans(Tween.TRANS_LINEAR) #nem tetszett a sziruett gyors eltünése ezért pontosítok egy kicsit a késleltetéssel

func resetPortrait(target: TextureRect) -> void:
	if PortreEntraceTween and PortreEntraceTween.is_valid():
		PortreEntraceTween.kill()
	if PortraitHomeReady:
		target.position = PortraitHomePos
		target.scale = PortraitHomeScale
		target.modulate = PortraitHomeModulate

func start_dialogue(lines: Array[String], CHARname: Array[String], color: Array[Color], tutorial: bool):
	currentPortrait = null
	resetPortrait(portrait)
	# ha a tutorial igaz a kis kép jelenik meg, ha hamis középen a nagy
	#game is paused, kivéve a Dialogue manager
	get_tree().paused = true
	#kiszedem az első elemeket a listából
	textcolor = color
	characters_name = CHARname
	dialogue_lines = lines
	current_line_index = 0
	isTutorial = tutorial
	
	is_dialogue_active = true
	dialogue_box.visible = true
	#frissítem a megjelenített szöveget
	updateLine()

func updateLine():
	#ha a narrátor beszél akkor nem kell név doboz
	if characters_name[current_line_index] == "":
		color_rect_2.visible = false
	else: color_rect_2.visible = true
	
	#felmerült egy hiba a typewriter funkcióban.
	#A char_count nem a fordított szöveg hosszát kapta meg,
	#hanem a localization kulcs nevének hosszát, ezt a tr() metódussal lehetett megoldani
	dialogue_text.text = tr(dialogue_lines[current_line_index])
	name_text.text = tr(characters_name[current_line_index])
	dialogue_text.self_modulate = textcolor[current_line_index]
	
	if current_line_index < Portraits.size() and Portraits[current_line_index]:
		#ha tutorial szöveget írunk ki
		if isTutorial:
			tutorialportrait.visible = true
			tutorialportrait.texture = Portraits[current_line_index]
		else:
			var newTexure: Texture2D = Portraits[current_line_index]
			var shouldAnimate: bool = current_line_index in entraceAnimIndexes
			#portrait.texture = Portraits[current_line_index]
			if newTexure != currentPortrait and not shouldAnimate:
				resetPortrait(portrait)
			
			portrait.texture = newTexure
			portrait.visible = true
			currentPortrait = newTexure
			
			if shouldAnimate:
				PlayPortraitEntrace(portrait)
			
	else:
		portrait.visible = false
		tutorialportrait.visible = false
		resetPortrait(portrait)
		currentPortrait = null
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
		portrait.visible = false
		tutorialportrait.visible = false
		
		currentPortrait = null
		resetPortrait(portrait)
		
		dialogue_finished.emit() #jelzek hogy vége van a beszélgetésnek
		print("dialogue_finished.emit()")
		
func typeWriterEffect():
	#ha már fut akkor megállítjuk
	if tween and tween.is_valid():
		tween.kill()
		
	dialogue_text.visible_characters = 0
	
	var char_count: int = dialogue_text.text.length()
	#print(char_count)
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
