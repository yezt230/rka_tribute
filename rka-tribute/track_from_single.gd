extends Node2D

@onready var track_from_single = $"."
@export var track_single : PackedScene
@onready var track_single_width : float
@onready var level_layer = get_tree().get_first_node_in_group("level")

func _ready():
	if track_single:
		var temp_instance = track_single.instantiate()
		var sprite = temp_instance.get_node("TrackSingle") # adjust path if needed		
		track_single_width = (sprite.texture.get_size() * sprite.scale).x		
		temp_instance.queue_free()
	print(track_single_width)

	
	#for ts in 30:
		##print("ts: " + str(ts) + " track width: " + str(track_single_width))
		##print("mult: " + str(ts * track_single_width))
#
		#var track_single_instance = track_single.instantiate()
#
		#add_child(track_single_instance)
		#print(level_layer)
		#track_single_instance.position = Vector2(((ts * track_single_width)/2) - 1500, 0)
		#print("pos: " + str(track_single_instance.global_position))
		#print(track_single_instance.position)


func _on_spawn_timer_timeout():
	print("new track")
	var track_single_instance = track_single.instantiate()
	add_child(track_single_instance)
	print(level_layer)
	track_single_instance.position = Vector2(-500, 0)
