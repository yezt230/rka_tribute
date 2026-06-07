extends State

func enter() -> void:
	parent.animation_player.play("shoot")
	parent.animation_player.animation_finished.connect(
		_on_animation_finished,
		CONNECT_ONE_SHOT
	)
	#@todo only play sound if projectile attack actually comes out
	parent.attack_sound_player.play_attack_sound()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "shoot":
		parent.state_machine.change_state(
			parent.resolve_locomotion_state()
		)
