extends Node2D

@export var attack:PackedScene
@onready var player = $".." as CharacterBody2D
@onready var collision_shape_2d = $"../CollisionShape2D" as CollisionShape2D
@onready var level_layer = get_tree().get_first_node_in_group("level")
@onready var v_offset = collision_shape_2d.shape.radius

func _ready():
	print(str(v_offset))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("SPACE"):
		var attack_instance = attack.instantiate()
		var direction: float = player.player_dir
		#print(str(player.player_dir))
		attack_instance.direction = direction
		level_layer.get_parent().add_child(attack_instance)
		
		var attack_spawn_coords: Vector2 = player.global_position
		attack_spawn_coords.y = attack_spawn_coords.y - (v_offset * 3)
		attack_instance.global_position = attack_spawn_coords
		
