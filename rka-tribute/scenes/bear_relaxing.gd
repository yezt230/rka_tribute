extends CharacterBody2D


func _on_player_rubbing_rubbing_started():
	$AnimationPlayer.play("rubbing1")


func _on_player_rubbing_rubbing_stopped():
	$AnimationPlayer.play("still")
