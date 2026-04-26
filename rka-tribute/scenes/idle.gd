extends State

@export var jump_state: State
@export var run_state: State
@export var shoot_state: State
@export var rub_standing_state: State
@onready var player = $"../.."

func enter() -> void:
	super()
	parent.animation_player.play("idle")

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("UP"):
		return jump_state
		#@todo centralize attack being dictated by the timer
	elif Input.is_action_just_pressed("SPACE") and player.attack_timer_ended:
		return shoot_state
	elif Input.is_action_just_pressed("LEFT") or Input.is_action_just_pressed("RIGHT"):
		return run_state
	else:
		return self
