extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#felmerült egy hiba ami a startwave számításainál kerekítési hibát eredményezett (BaseSpeed függvény nullát adott vissza. az elég lassu ngl)
# int / int = lefelekerekítés int. ezért a konstansok float értékek kell legyenek
var bpm = 120.0
const Frames:float = 44.0
const fps:float = 60.0
const beatsPerWave:float = 2.0

var waveHitTime = 0.0
var waveActive = false

#idő számítások... kegyetlen de legalább nincs benne magic number
func BaseSpeed() -> float:
	var natural := Frames / fps
	var target:float = beatsPerWave * 60.0 / bpm
	return natural / target


func startWave(speed_szorzo:float = 1.0) -> void:
	visible = true
	var speed_scale := BaseSpeed() * speed_szorzo
	var duration := (Frames/fps) / speed_scale
	waveHitTime = Time.get_ticks_msec() / 1000.0 + duration
	waveActive = true
	animated_sprite_2d.speed_scale = speed_scale
	animated_sprite_2d.play("waving")
#felmerült egy hiba... kezd ez már el mémesülni. minden második csepp után nem keletkezett hullám. mert a kód nem kezelte ha a játékos nem is kattint de az animáció már végigment
func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("idle")
	
	#ha a játékos egyáltalán nem kattint akkor a hullám ott marad a következő hullám kezdetéig mozdulatlanul. ezt kezelem itt,
	await  get_tree().create_timer(0.2).timeout
	if waveActive:
		visible = false
		waveActive = false
