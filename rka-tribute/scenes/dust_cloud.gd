extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_cloud() -> void:
	visible = true
	animation_player.play("billow")


func reset_cloud() -> void:
	animation_player.stop()
	animation_player.seek(0.0, true)
	visible = false
