extends State

@export var jump_state: State
@export var idle_state: State
@export var shoot_state: State

var	player_sprite
var	sprite_scale
var collision
var collision_coords

func enter() -> void:
	super()
	

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('UP'):
		return jump_state		
	elif Input.is_action_just_pressed('SPACE'):
		return shoot_state		
	else:
		return idle_state
	return null
