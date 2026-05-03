extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"
@onready var phase_2 = $"../Phase2"
@onready var phase_1 = $"../Phase1"
@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var level = get_tree().get_first_node_in_group("Level")
@onready var health_component = boss.get_node("HealthComponent")

func enter():
	#consult boss.gd for phase descriptions
	phase_transition_timer.start()
	parent.phase += 1
	if parent.phase == 3:
		level.get_node("TrackFromSingle2").activate_spawning()
		parent.global_position = Vector2(-300, 156)
		health_component.health = health_component.starting_health


func _on_phase_transition_timer_timeout():
	#print("phase: " + str(parent.phase))
	match parent.phase:
		1:
			parent.state_machine.change_state(phase_1)
		2:
			parent.state_machine.change_state(self)
		3:
			parent.state_machine.change_state(phase_2)
