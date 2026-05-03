extends Node2D

@export var attack: PackedScene
@onready var attack_timer = $AttackTimer
@onready var cannon_particles = $"../OrbSpawner/CannonParticles"
@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var orb_cannon = $"../OrbSpawner/OrbCannon"
@onready var orb_cannon_animation_player = orb_cannon.get_node("AnimationPlayer")

func _ready():
	attack_timer.timeout.connect(on_timer_timeout)
	orb_cannon.position = Vector2(0, 0)
	

func on_timer_timeout():
	var orb_instance = attack.instantiate() as Area2D
	var orb_spawn_point : Marker2D = get_tree().get_first_node_in_group("orbspawner")
	var foreground_layer = get_tree().get_first_node_in_group("foregroundlayer")
	if foreground_layer and orb_instance:
		orb_cannon_animation_player.play("fire")
		foreground_layer.get_parent().add_child(orb_instance)
		
		orb_instance.global_position = orb_spawn_point.global_position
		cannon_particles.restart()
