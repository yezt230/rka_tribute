extends State

@export var idle_state: State

var reserved_state: State = null

func enter() -> void:
	super()
	parent.animation_player.play("shoot")
	parent.not_in_hp_state = false
	if parent.reserved_state:
		reserved_state = parent.reserved_state
		
	parent.animation_player.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))

#func process_input(_event: InputEvent) -> State:
	#if Input.is_action_just_pressed('UP'):
		#return jump_state		
	#elif Input.is_action_just_pressed('LEFT'):
		#return run_state		
	#elif Input.is_action_just_pressed('RIGHT'):
		#return run_state
	#return null


func _on_animation_player_animation_finished(anim_name):
	parent.not_in_hp_state = true
	if parent.reserved_state:
		parent.state_machine.change_state(parent.reserved_state)
