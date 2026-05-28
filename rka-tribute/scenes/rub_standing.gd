extends State

@export var idle_state: State
@export var run_state: State
@onready var rubbing_shake_inc_timer = $"../../RubbingShakeIncTimer"

func enter() -> void:
	super()
	parent.animation_player.play("rub_standing")
	if parent.direction_to_play_rubbing_anim < 0.0:
		parent.animation_player.seek(0.6, true)
	parent.emit_signal("rubbing_started")
	
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("SPACE"):
		if Input.is_action_just_pressed("LEFT") or Input.is_action_just_pressed("RIGHT"):
			return run_state
		else:
			return idle_state
	else:
		return self
		
		
func exit() -> void:
	super()
	parent.emit_signal("rubbing_stopped")
