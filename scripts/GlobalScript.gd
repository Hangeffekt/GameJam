extends Node

var language = "eng"
var nextcustomer = 0

var script_fajl = load("res://scripts/load_datas.gd")

func _ready() -> void:
	
	var objects = script_fajl.new()
	objects._ready()
