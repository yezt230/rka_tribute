extends Node2D

@export var attack:PackedScene
@onready var player = $".." as CharacterBody2D
@onready var collision_shape_2d = $"../CollisionShape2D" as CollisionShape2D
@onready var marker_2d = $"../Marker2D" as Marker2D
@onready var level_layer = get_tree().get_first_node_in_group("level")
@onready var state_machine = $"../StateMachine"
@onready var attack_delay_timer = $AttackDelayTimer
@onready var parent = get_parent()
	
func _physics_process(_delta: float) -> void:
	var current_state = state_machine.current_state
	if current_state and current_state.name == "Hurt":
		return
	if Input.is_action_just_pressed("SPACE") and parent.attack_timer_ended:
		parent.attack_timer_ended = false
		attack_delay_timer.start()
		
		var attack_instance = attack.instantiate()
		var direction: float = player.player_dir
		
		attack_instance.direction = direction
		level_layer.get_parent().add_child(attack_instance)
		
		var attack_spawn_coords: Vector2 = marker_2d.global_position
		#attack_spawn_coords.y = attack_spawn_coords.y - (v_offset * 3)
		attack_spawn_coords.y = attack_spawn_coords.y
		attack_instance.global_position = attack_spawn_coords	


func _on_attack_delay_timer_timeout():
	print("can attack again")
	parent.attack_timer_ended = true
