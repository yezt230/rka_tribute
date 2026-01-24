extends State

@export var idle_state: State
@export var shoot_state: State
@export var run_state: State

func enter() -> void:
	parent.animation_player.play("midair_mid")

func physics_update(_delta: float) -> State:
	# Animation selection
	if parent.velocity.y < -400:
		parent.animation_player.play("midair_rising")
	elif parent.velocity.y > 400:
		parent.animation_player.play("midair_falling")
	else:
		parent.animation_player.play("midair_mid")

	# Landing logic
	if parent.is_on_floor():
		return run_state if parent.velocity.x != 0 else idle_state

	return null

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("SPACE"):
		return shoot_state
	return null
