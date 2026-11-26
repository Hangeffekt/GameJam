extends CanvasLayer

@onready var box: Sprite2D = $DialogueBox/Box
@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/dialogueText
@onready var namebox: Sprite2D = $DialogueBox/Namebox
@onready var name_text: RichTextLabel = $DialogueBox/Namebox/NameText
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

##Karakterhangok
@export var voice_indices: Array[int] = []
@export var voice_sound: AudioStream
@export_range(0.0, 0.5, 0.01) var voice_pitch_variation: float = 0.08
@export var voice_volume_db: float = -6.0
@export var voice_bus: StringName = &"SFX"
@export_range(1, 16, 1) var voice_player_pool_size: int = 4
@export var voice_enabled: bool = true

var _voice_players: Array[AudioStreamPlayer] = []
var _voice_player_index: int = 0
var _last_blip_visible: int = -1
var _cached_parsed_text: String = ""
var _voice_active_this_line: bool = false

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

var doorAnimIndexes: Array[int] = []


const time_per_char: float = 0.03

var tween: Tween

var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready() -> void:
	TranslationServer.set_locale(GlobalScript.language)
	dialogue_box.visible = false
	Capture_portrait_home.call_deferred()
	_build_voice_pool()

func _build_voice_pool() -> void:
	_voice_players.clear()
	for i in voice_player_pool_size:
		var p := AudioStreamPlayer.new()
		p.bus = voice_bus
		p.volume_db = voice_volume_db
		add_child(p)
		_voice_players.append(p)

func play_blip() -> void:
	if not voice_enabled or voice_sound == null or _voice_players.is_empty():
		return
	var p := _voice_players[_voice_player_index]
	_voice_player_index = (_voice_player_index + 1) % _voice_players.size()
	p.stream = voice_sound
	p.pitch_scale = 1.0 + randf_range(-voice_pitch_variation, voice_pitch_variation)
	p.volume_db = voice_volume_db
	p.play()

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
		namebox.visible = false
	else: namebox.visible = true
	
	#felmerült egy hiba a typewriter funkcióban.
	#A char_count nem a fordított szöveg hosszát kapta meg,
	#hanem a localization kulcs nevének hosszát, ezt a tr() metódussal lehetett megoldani
	dialogue_text.text = tr(dialogue_lines[current_line_index])
	name_text.text = "[b][i]" + tr(characters_name[current_line_index]) + "[/i][/b]"
	dialogue_text.self_modulate = textcolor[current_line_index]
	
	if current_line_index < Portraits.size() and Portraits[current_line_index]:
		#ha tutorial szöveget írunk ki
		if isTutorial:
			tutorialportrait.visible = true
			tutorialportrait.texture = Portraits[current_line_index]
		else:
			var newTexure: Texture2D = Portraits[current_line_index]
			var shouldAnimate: bool = current_line_index in entraceAnimIndexes
			
			##perpillanat nem használt blokk. delete later maybe
			var shouldOpenDoor: bool = current_line_index in doorAnimIndexes
			if shouldOpenDoor:
				GlobalScript.DoorWouldOpen.emit()
				print("DoorWouldOpen.emit()")
			
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
	_last_blip_visible = -1
	_cached_parsed_text = dialogue_text.get_parsed_text()
	_voice_active_this_line = current_line_index in voice_indices
	
	var char_count: int = dialogue_text.text.length()
	var realTime: float = char_count * time_per_char
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(_on_typewriter_step, 0.0, float(char_count), realTime)

func _on_typewriter_step(value: float) -> void:
	var v: int = int(value)
	
	if v != _last_blip_visible:
		if v > _last_blip_visible and v > 0 and _voice_active_this_line:
			var idx := v - 1
			if idx < _cached_parsed_text.length():
				var ch := _cached_parsed_text[idx]
				if ch != " " and ch != "\n" and ch != "\t" and ch != "\r":
					play_blip()
		_last_blip_visible = v
	dialogue_text.visible_characters = v

func skipTyping():
	if tween and tween.is_valid():
		tween.kill()
	dialogue_text.visible_ratio = 1.0

func isTyping() -> bool:
	return tween and tween.is_valid() and dialogue_text.visible_ratio < 1.0
