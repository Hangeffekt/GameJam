extends HSlider

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(audio_bus_id, 0.55) #játék indításakor kirobban a füled ezért inkább lenebb veszem már alapból a hangot

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(audio_bus_id, value)
	print(value)
	
