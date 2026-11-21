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
	var icon
	if get_tree().current_scene is Node2D or get_tree().current_scene is CanvasLayer:
		icon = get_tree().current_scene.get_node("TutorialButton")
	else:
		#3d sceene
		icon = get_tree().current_scene.get_node("CanvasLayer/TutorialButton")
	icon.visible = true
