extends Node2D

@onready var wave: Node2D = $wave
@onready var animation_player: AnimatedSprite2D = $wave/AnimatedSprite2D
@onready var test_metronome_120_bpm: AudioStreamPlayer = $"test_metronome 120bpm"
@onready var dropplet_anim: AnimationPlayer = $dropplet_placeholderr/DroppletAnimationPlayer
@onready var dropplet_placeholderr: Sprite2D = $dropplet_placeholderr
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var victory_label: Label = $"ProgressBar/victory label"
@onready var particles: AnimatedSprite2D = $HitText/Particles
@onready var hit_text: Label = $HitText
@onready var perfect_hullam_effect: AnimatedSprite2D = $perfectHullamEffect
@onready var camera: Camera2D = $Camera2D



#egy ritmus játéknál ahol a zenei visszajelzés is fontos, a lehető legpontosabbnak kell lenni idő szerint. ezért a csepp logikáját is meg kell változtatnom :") 
#bpm nem @export mert ha kint változtatom az értékét akkor a számított érték itt nem fog változni elvileg, hacsak nem írok egy settert. 
var bpm: float = 120.0 ##FONTOS ha ezt átállítod akkor a wave_scropt.gd ben is a bpmet állítsd át ugyanarra a számra
#elfogadási értékek mp-ben
const perfect_window: float = 0.060
const good_window: float = 0.120
var beatsPerDrop:float = 4.0

##csepp
var nextIsAlternative:bool = false
var alternativeChance:float = 0.50
@export var normalTexture: Texture2D
@export var alternateTexture: Texture2D

##tutorial button
@onready var tutorialScene: CanvasLayer = $Tutorial
@onready var tutorialBtn: Button = $TutorialButton

##stars
@onready var stars_collection: Node2D = $stars_collection
@onready var stars: Array[Star] = []
var cursor = 0 #ezzel figyelem melyik csillagnál járunk a listában
var done = false #ha nyert a játékos akkor ne kezeljük az inputokat

##progressbar
var progress_tween: Tween
var target_value: float

##hitText
var hitTween: Tween
var labelOriginPos: Vector2

##camera
var shakeTween:Tween
var cameraOriginPos: Vector2

# felmerült egy hiba ahol ha a játékos spamelte az interact inputot, akkor töbször kapott pontot az "1 pont / hullám" helyett. 
# ezért egy sima ellenörzés miatt csináltam ezt a változót. ami lehetne bool is de idgaf
var antispam = 1
const maxpoints = 20


func _input(event: InputEvent) -> void:
	#kivételkezelések
	if done or antispam == 0:
		return
	if not event.is_action_pressed("interact"):
		return
	if not wave.waveActive:
		return #nincs hullám, minek ellenőrizni?
		
	antispam = 0
	var now := Time.get_ticks_msec() / 1000.0
	var diff:float = now - wave.waveHitTime
	var absoluteDiff:float = abs(diff) 
	
	if absoluteDiff <= perfect_window:
		#wave.visible = false
		HitText("PERFECT")
		pontszerzes(2)
		particles.play("run")
		perfect_hullam_effect.play_backwards("run") #visszafele játszva szerintem jobban működik. rendesen futtatva összezavarhatja a játékost
	
	elif absoluteDiff <= good_window:
		#wave.visible = false
		HitText("GOOD")
		pontszerzes(1)
		particles.play("run")
	
	else:
		#wave.visible = false
		HitText("MISS")
		camera_shake(10.0, 0.5)
		
	wave.visible = false
	wave.waveActive = false
	animation_player.play("idle")

func _ready() -> void:
	#be kell állítani az original pozíciókat mert különben szépen lassan kimegyünk a képernyőből
	cameraOriginPos = camera.offset
	labelOriginPos = hit_text.position
	
	##DROPPLET
	test_metronome_120_bpm.play() #le tesztelem "zenével". a beat lassan elcsúszik de itt lehet a hangfile-al van probléma.
	var targetDuration:float = beatsPerDrop * 60 / bpm
	var naturalDuration:float = dropplet_anim.get_animation("dropping").length
	dropplet_anim.speed_scale = naturalDuration / targetDuration
	dropplet_anim.animation_finished.connect(_on_dropplet_animation_player_animation_finished)
	start_drop() #elindítjuk az első cseppet
	
	
	##STARS
	#összegyüjtöm a sok csillag objektumot a stars listába
	for child in stars_collection.get_children():
		if child is Star:                 
			stars.append(child)
	
	for star in stars:
		star.phasesignal.connect(_on_phasesignal)

#következő 3 func a csepphez tartozik
func on_drop_timer_timeout() -> void:
	start_drop()

func start_drop() -> void:
	nextIsAlternative = randf() < alternativeChance #randf 1 és 0 között ad vissza értéket
	
	if nextIsAlternative:
		dropplet_placeholderr.texture = alternateTexture
	else:
		dropplet_placeholderr.texture = normalTexture
	
	dropplet_anim.stop()
	dropplet_anim.play("dropping")

func HitText(text: String) -> void:
	
	if hitTween and hitTween.is_running():
		hitTween.kill()
	
	hit_text.text = text
	hit_text.modulate.a = 1.0
	hit_text.visible = true
	hit_text.position = labelOriginPos
	
	#forgatás középpontját a szöveg középpontjához igazítom
	hit_text.pivot_offset = hit_text.size / 2.0
	
	var random_angle:float = deg_to_rad(randf_range(-15.0, 15.0))
	hit_text.rotation = random_angle
	
	var start_pos:Vector2 = hit_text.position
	var end_pos:Vector2 = start_pos + Vector2(0, -60)
	
	##tween
	hitTween = create_tween()
	hitTween.set_parallel(true) #hogy az alábbi animok egyszerre fussanak
	
	hitTween.tween_property(hit_text, "position", end_pos, 0.6) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	hitTween.tween_property(hit_text, "rotation", random_angle * 1.5, 0.6) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)
	
	hitTween.tween_property(hit_text, "modulate:a", 0.0, 0.6) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_IN)
	
	#vége a tween-nek, feliratot eltüntetjük
	hitTween.chain().tween_callback(func(): hit_text.visible = false)

func camera_shake(intensity:float, duration:float) -> void:
	if shakeTween and shakeTween.is_running():
		shakeTween.kill()
	camera.offset = cameraOriginPos
	
	shakeTween = create_tween()
	var steps: int = 10 #apró mozgások száma
	var step_time: float = duration / steps #apró mozgások között eltelt idő
	
	for i in range(steps):
		var decay: float = 1.0 - (float(i) / float(steps)) # minden lépéssel egyre gyengébb lesz a rezgés. decay-el
		var randomOffset: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * intensity * decay
		shakeTween.tween_property(camera, "offset", cameraOriginPos + randomOffset, step_time)
	
	shakeTween.tween_property(camera, "offset", cameraOriginPos, step_time)

#amikor a csepp leesik (anim finished) akkor csinál egy hullámot
func _on_dropplet_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dropping":
		wave.visible = true
		if nextIsAlternative:
			wave.startWave(2.0)
		else:
			wave.startWave()
		antispam = 1
		start_drop()

func pontszerzes(value: int) -> void:
	target_value = progress_bar.value + float(value)
	
	var remaining: int = value
	while remaining > 0 and cursor < stars.size():
		stars[cursor].advance()
		remaining -= 1
		if stars[cursor].phase >= 2:
			cursor += 1
			
	if cursor >= stars.size():
		print("minden csillag maxon van")
		
	##progressbar
	if progress_tween and progress_tween.is_running():
		progress_tween.kill()
	progress_tween = create_tween()
	progress_tween.tween_property(progress_bar, "value", target_value, 0.3) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)
	
	##ha elértük a max pontot
	if target_value >= maxpoints and not done:
		done = true
		await progress_tween.finished
		victory_label.visible = true
		dropplet_anim.stop()
		await get_tree().create_timer(3.0).timeout
		GlobalScript.nextcustomer = GlobalScript.nextcustomer + 1
		SceneTransition.change_scene("res://scenes/shop.tscn")

func _on_phasesignal(index: int, phase: int) -> void:
	print("Star ", index, " phase: ", phase)

func _on_tutorial_button_pressed() -> void:
	tutorialScene.visible = true
	tutorialScene.choose_tutorial(3)
