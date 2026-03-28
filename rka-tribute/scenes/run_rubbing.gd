extends State

@export var idle_state: State
@export var rub_standing_state: State
@export var rub_crouching_state: State
@export var jump_state: State

func enter() -> void:
	super()
	if parent.is_on_floor():
		parent.animation_player.play("run")


func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("UP"):
		return jump_state
	elif Input.is_action_just_pressed("SPACE"):
		if parent.is_on_belly_platform:
			return rub_crouching_state
		else:
			return rub_standing_state
	elif not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		return idle_state
	return null
