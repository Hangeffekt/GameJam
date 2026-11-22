extends CanvasLayer

#egy hiba miatt az intro sceneben nem jelenik meg a szöveg ha nem várjuk meg teljesen a fade out-ot
signal transitionFin

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	
	await get_tree().process_frame #varunk 1 frame-et
	
	$AnimationPlayer.play_backwards("dissolve")
	await $AnimationPlayer.animation_finished
	
	transitionFin.emit()

func quit_game() -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
