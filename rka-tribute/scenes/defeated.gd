extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"

func enter():
	parent.phase += 1
	phase_transition_timer.start()
