extends State

@export var idle_state: State
@export var run_state: State
@onready var rubbing_shake_inc_timer = $"../../RubbingShakeIncTimer"

func enter() -> void:
	super()
	parent.animation_player.play("rub_standing")
	parent.is_rubbing = true
	#rubbing_shake_inc_timer.start()
	
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("SPACE"):
		if Input.is_action_just_pressed("LEFT") or Input.is_action_just_pressed("RIGHT"):
			return run_state
		else:
			return idle_state
	else:
		return self
		
		
func exit() -> void:
	parent.is_rubbing = false
	#rubbing_shake_inc_timer.stop()
