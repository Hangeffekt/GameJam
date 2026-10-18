extends HSlider

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index("SFX")

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(audio_bus_id, value)
