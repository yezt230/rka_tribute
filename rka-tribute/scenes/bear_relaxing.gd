extends CharacterBody2D

@onready var shake_count : int = 0
@onready var shake_animation_player = $ShakeAnimationPlayer


func _process(delta):
	print("shake count: " + str(shake_count))
	if shake_count > 2000 and shake_count < 5000:
		shake_animation_player.play("rub_3")
	elif shake_count >= 5000:
		shake_animation_player.play("shake_1")

func _on_player_rubbing_rubbing_started():
	shake_count += 1
	$AnimationPlayer.play("rubbing1")


func _on_player_rubbing_rubbing_stopped():
	$AnimationPlayer.play("still")
