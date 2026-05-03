extends Node2D

@onready var track_from_single = $"."
@export var track_single : PackedScene
enum Mode { MAIN, RUBBING, SECOND }
@export var mode: Mode
@onready var track_single_width : float
@onready var level_layer = get_tree().get_first_node_in_group("level")

@onready var activated_yet : bool = false
@onready var amount_of_tracks_to_spawn : int = 24
@onready var track_single_spwan_incrementer : int = 0
@onready var spawn_timer = $SpawnTimer

func _ready():
	match mode:
		Mode.MAIN:
			main_track_animation()
		#Mode.SECOND:
			#activate_spawning()

#the elevated track
func activate_spawning():
	#if not activated_yet:
	#activated_yet = true
	track_single_spwan_incrementer = 0
	spawn_timer.start()
			
			
func main_track_animation():
	spawn_timer.queue_free()
	for ts in amount_of_tracks_to_spawn:
		var track_single_instance = track_single.instantiate()
		var ts_anim = track_single_instance.get_node("TrackSingle/AnimationPlayer")
		if ts_anim:
			ts_anim.play("track_single_loop")
			#dynamically get 1.1 (the animation length?)
			var step : float = 1.1/23
			var step2 : float = ts * step
			ts_anim.seek(step2, true)
		add_child(track_single_instance)
		#track_single_instance.position = Vector2(ts * 65, 0)
		track_single_instance.position = Vector2(-500, 0)



# @todo this keeps spawning unlimited new tracks even after
# enough looping ones are already onscreen
func _on_spawn_timer_timeout():
	if track_single_spwan_incrementer < amount_of_tracks_to_spawn:
		track_single_spwan_incrementer += 1
		#print("spawn inc: " + str(track_single_spwan_incrementer))
		var track_single_instance = track_single.instantiate()
		var ts_anim = track_single_instance.get_node("TrackSingle/AnimationPlayer")
		if ts_anim:
			ts_anim.play("track_single_loop")
		track_single_instance.scale.y = 0.5
		add_child(track_single_instance)
		track_single_instance.position = Vector2(-500, 0)
	else:
		spawn_timer.stop()
