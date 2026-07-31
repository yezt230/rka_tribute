extends Node2D

@export var attack: PackedScene
@onready var attack_timer = $AttackTimer
@onready var cannon_particles : GPUParticles2D = $"../OrbSpawner/CannonParticles"
@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var orb_cannon = $"../OrbSpawner/OrbCannon"
@onready var orb_stream_attack_player = $"../OrbAttackPlayer"
@onready var orb_cannon_animation_player = orb_cannon.get_node("AnimationPlayer")

func _ready():
	print(cannon_particles)
	attack_timer.timeout.connect(on_timer_timeout)
	if orb_cannon:
		orb_cannon.position = Vector2(0, 0)
	

func on_timer_timeout():
	var orb_instance = attack.instantiate() as Area2D
	var orb_spawn_point : Marker2D = get_tree().get_first_node_in_group("orbspawner")
	var foreground_layer = get_tree().get_first_node_in_group("foregroundlayer")
	if foreground_layer and orb_instance:
		if orb_cannon:
			#debug: boss orb attack sfx
			orb_stream_attack_player.play()
			orb_cannon_animation_player.play("fire")
		foreground_layer.get_parent().add_child(orb_instance)
		
		print("Particles local position: ", cannon_particles.position)
		print("Particles global position: ", cannon_particles.global_position)
		print("Spawn point global position: ", orb_spawn_point.global_position)
		
		orb_instance.global_position = orb_spawn_point.global_position
		if not OS.has_feature("web"):
			cannon_particles.restart()
