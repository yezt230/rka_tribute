extends Node2D

@export var attack:PackedScene
@onready var player = $".." as CharacterBody2D
@onready var collision_shape_2d = $"../CollisionShape2D" as CollisionShape2D
@onready var marker_2d = $"../Marker2D" as Marker2D
@onready var level_layer = get_tree().get_first_node_in_group("level")


func _ready():
	pass


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("SPACE"):
		var attack_instance = attack.instantiate()
		var direction: float = player.player_dir
		
		attack_instance.direction = direction
		level_layer.get_parent().add_child(attack_instance)
		
		var attack_spawn_coords: Vector2 = marker_2d.global_position
		#attack_spawn_coords.y = attack_spawn_coords.y - (v_offset * 3)
		attack_spawn_coords.y = attack_spawn_coords.y
		attack_instance.global_position = attack_spawn_coords
		
