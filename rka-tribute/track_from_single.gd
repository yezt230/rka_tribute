extends Node2D

@onready var track_from_single = $"."
@export var track_single : PackedScene
enum Mode { MAIN, RUBBING }
@export var mode: Mode = Mode.MAIN
@onready var track_single_width : float
@onready var level_layer = get_tree().get_first_node_in_group("level")
@onready var which_animation : String
@onready var spawn_timer = $SpawnTimer

func _ready():
	if track_single:
		var temp_instance = track_single.instantiate()
		var sprite = temp_instance.get_node("TrackSingle") # adjust path if needed		
		track_single_width = (sprite.texture.get_size() * sprite.scale).x		
		temp_instance.queue_free()
		
		match mode:
			Mode.MAIN:
				which_animation = "track_single_loop"
			Mode.RUBBING:
				which_animation = "track_single_transition"
				spawn_timer.stop()
				

func spawn_rubbing_segments():
	for t in 50:
		var track_single_instance = track_single.instantiate()
		var ts_anim = track_single_instance.get_node("TrackSingle/AnimationPlayer")
		if ts_anim:
			ts_anim.play("track_single_transition")
		add_child(track_single_instance)
		track_single_instance.position = Vector2(t * 63, 0)


# @todo this keeps spawning unlimited new tracks even after
# enough looping ones are already onscreen
func _on_spawn_timer_timeout():
	var track_single_instance = track_single.instantiate()
	var ts_anim = track_single_instance.get_node("TrackSingle/AnimationPlayer")
	if ts_anim:
		ts_anim.play(which_animation)
	add_child(track_single_instance)
	track_single_instance.position = Vector2(-500, 0)
