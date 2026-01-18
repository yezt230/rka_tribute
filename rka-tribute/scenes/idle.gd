extends State

@export var jump_state: State
@export var run_state: State
@export var shoot_state: State

func enter() -> void:
	super()
	parent.animation_player.play("idle")
	

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('UP'):
		return jump_state		
	elif Input.is_action_just_pressed('LEFT'):
		return run_state		
	elif Input.is_action_just_pressed('RIGHT'):
		return run_state
	return null
