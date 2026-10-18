extends Node2D


func start_wave() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("waving")
	$AnimatedSprite2D/AnimationPlayer.stop()
	$AnimatedSprite2D/AnimationPlayer.play("waweing")
