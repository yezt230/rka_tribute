extends Node2D

@export var attack: PackedScene
@onready var attack_timer = $AttackTimer

func _ready():
	attack_timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var orb_instance = attack.instantiate() as CharacterBody2D
	var orb_spawn_point : Marker2D = get_tree().get_first_node_in_group("orbspawner")
	var foreground_layer = get_tree().get_first_node_in_group("foregroundlayer")
	foreground_layer.get_parent().add_child(orb_instance)
	orb_instance.global_position = orb_spawn_point.global_position
	#print(orb_instance.global_position)
