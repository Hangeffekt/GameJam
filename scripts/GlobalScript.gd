extends Node

var language = "hun"
var nextcustomer = 0
var potiongrade = ""
var tarotgarde = ""

var script_fajl = load("res://scripts/load_datas.gd")

func _ready() -> void:
	
	var objects = script_fajl.new()
	objects._ready()
	
func show_tutorial_icon() -> void:
	print(get_tree().current_scene)
	var icon = get_tree().current_scene.get_node("TutorialButton")
	icon.visible = true
