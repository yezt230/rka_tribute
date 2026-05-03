extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"

func enter():
	parent.phase += 1
	phase_transition_timer.start()
	#removing claw hitboxes when boss is defeated in Phase 2
	if parent.phase == 4:
		var claws = get_tree().get_nodes_in_group("claws")
		for claw in claws:
			var claw_hitbox = claw.get_node("PlayerColliderBox") as Area2D
			claw_hitbox.queue_free() 
