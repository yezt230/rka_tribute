extends State

func enter() -> void:
	parent.animation_player.play("shoot")
	parent.animation_player.animation_finished.connect(
		_on_animation_finished,
		CONNECT_ONE_SHOT
	)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "shoot":
		parent.state_machine.change_state(
			parent.state_machine.previous_state
		)
