extends Node2D

@export var dust_cloud_scene: PackedScene
@export var dust_delay: float = 0.20


@onready var dust_spawn_points: Array[Marker2D] = [
	$DustSpawn1,
	$DustSpawn2,
	$DustSpawn3,
]


func play_truck_entrance() -> void:
	# Start the truck's movement here.
	play_dust_sequence()


func play_dust_sequence() -> void:
	for spawn_point in dust_spawn_points:
		spawn_dust_cloud(spawn_point.global_position)
		await get_tree().create_timer(dust_delay).timeout


func spawn_dust_cloud(spawn_position: Vector2) -> void:
	var cloud := dust_cloud_scene.instantiate()
	get_tree().current_scene.add_child(cloud)

	cloud.global_position = spawn_position
	cloud.play_cloud()
