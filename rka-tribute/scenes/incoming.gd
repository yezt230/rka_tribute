extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"
@onready var phase_2 = $"../Phase2"
@onready var phase_1 = $"../Phase1"
@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var level = get_tree().get_first_node_in_group("Level")
@onready var health_component = boss.get_node("HealthComponent")
@onready var second_claw_spawn_timer = $"../../SecondClawSpawnTimer"

var claw_attack_manager: PackedScene = preload("res://scenes/boss_claw_attack_manager.tscn")

func enter():
	#consult boss.gd for phase descriptions
	phase_transition_timer.start()
	parent.phase += 1	
	#when boss changes to attack phase 2 (elevated track w/ claw attack)
	if parent.phase == 3:
#		create the claws
		spawn_claw()
		second_claw_spawn_timer.start()
		
		level.get_node("TrackFromSingle2").activate_spawning()
		#DEBUG: boss_timings: phase 2 position
		#parent.global_position = Vector2(-900, 156)
		parent.global_position = Vector2(-300, 156) if  OS.is_debug_build() else Vector2(-1100, 156)
		#truck is damaged in phase 2
		parent.truck_body_sprite.frame = 1
		#parent.global_position = Vector2(-850, 156)
		health_component.health = health_component.starting_health
		if parent.get_node("BossOrbAttackManager"):
			parent.get_node("BossOrbAttackManager").queue_free()
		if parent.get_node("OrbSpawner"):
			parent.get_node("OrbSpawner").queue_free()


func spawn_claw():
	var claw = claw_attack_manager.instantiate()
	claw.position = Vector2(-200, 0)
	if boss:
		boss.add_child(claw)


func _on_phase_transition_timer_timeout():
	match parent.phase:
		1:
			parent.state_machine.change_state(phase_1)
		2:
			parent.state_machine.change_state(self)
		3:
			parent.state_machine.change_state(phase_2)


func _on_second_claw_spawn_timer_timeout():
	spawn_claw()
