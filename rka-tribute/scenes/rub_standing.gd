extends State

@export var idle_state: State
@export var run_state: State

func enter() -> void:
	super()
	parent.animation_player.play("rub_standing")

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("SPACE"):
		if Input.is_action_just_pressed("LEFT") or Input.is_action_just_pressed("RIGHT"):
			return run_state
		else:
			return idle_state
	else:
		return self
