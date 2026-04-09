extends CharacterBody2D

@onready var bear_belly_platform = $"../BearBellyPlatform"

func _on_player_rubbing_rubbing_started():
	$AnimationPlayer.play("rubbing1")


func _on_player_rubbing_rubbing_stopped():
	$AnimationPlayer.play("still")


func _on_area_2d_area_entered(_area):
	bear_belly_platform.queue_free()
	queue_free()
