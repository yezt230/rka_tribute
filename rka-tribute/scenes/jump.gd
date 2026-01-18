extends State

@export var idle_state: State
@export var shoot_state: State

func enter() -> void:
	super()
	print("jump")
	

func physics_update(_delta: float) -> State:
	if parent.is_on_floor():
		return idle_state
	return null


func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('SPACE'):
		return shoot_state
	return null
