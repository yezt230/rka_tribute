extends CharacterBody2D


@onready var bear_belly_platform = $"../BearBellyPlatform"
@onready var belly_animation_player = $AnimationPlayer
@onready var shake_animation_player = $ShakeAnimationPlayer
@onready var boss_animation_player = $"../Boss/AnimationPlayer"
#DEBUG: change this node's duration to rub the bear's belly faster & proceed
@onready var rubbing_shake_inc_timer = $RubbingShakeIncTimer
@onready var shake_label = $ShakeLabel
@onready var player_rubbing = $"../PlayerRubbing"
@onready var player_shake_animation_player: AnimationPlayer = $"../PlayerRubbing/ShakeAnimationPlayer"
@onready var rub_stream_player = $RubStreamPlayer
@onready var boss = $"../Boss"

var is_player_overlapping := false
var is_player_rubbing := false
var bear_shake_tracker : int = 0
var has_shake_timer_started : bool = false

func _ready() -> void:
	rubbing_shake_inc_timer.timeout.connect(_on_rubbing_shake_inc_timer_timeout)
	player_rubbing.rubbing_started.connect(_on_player_rubbing_rubbing_started)
	player_rubbing.rubbing_stopped.connect(_on_player_rubbing_rubbing_stopped)
	player_rubbing.land_on_belly.connect(_on_land_on_belly)
# --- PLAYER SIGNALS ---

func _process(_delta):
	shake_label.text = "%.2f" % rubbing_shake_inc_timer.time_left


func _on_player_rubbing_rubbing_started() -> void:
	is_player_rubbing = true
	evaluate_rub_state()


func _on_player_rubbing_rubbing_stopped() -> void:
	is_player_rubbing = false
	stop_rubbing()


func evaluate_rub_state() -> void:
	if not is_player_overlapping or not is_player_rubbing:
		return

	if belly_animation_player.current_animation in ["rubbing1", "rubbing1_reverse", "rubbing2"]:
		return

	start_rubbing()	


func start_rubbing() -> void:
	var anim_to_play := "rubbing2" if player_rubbing.is_on_belly_platform else "rubbing1"

	if anim_to_play == "rubbing1" and player_rubbing.direction_to_play_rubbing_anim < 0.0:
		anim_to_play = "rubbing1_reverse"

	belly_animation_player.play(anim_to_play)

	rub_stream_player.play_random()

	if has_shake_timer_started:
		rubbing_shake_inc_timer.paused = false
	else:
		rubbing_shake_inc_timer.start()
		has_shake_timer_started = true


func stop_rubbing() -> void:
	belly_animation_player.play("still")
	rub_stream_player.stop()
	rubbing_shake_inc_timer.paused = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "RubHitbox":
		$"../StallTimer".start()
		if bear_belly_platform:
			bear_belly_platform.queue_free()
		queue_free()


func _on_rubbing_shake_inc_timer_timeout() -> void:
	match bear_shake_tracker:
		0:
			shake_animation_player.play("rub_5")
		1:
			shake_animation_player.play("rub_4")
			player_shake_animation_player.play("shake")
		2:
			shake_animation_player.play("rub_3")
		3:
			player_shake_animation_player.play("still")
			spawn_and_move_train()
			return

	bear_shake_tracker += 1


func spawn_and_move_train():
	boss.modulate.a = 1.0
	boss.get_node("SoundPlayer").play_horn_sound()
	boss.get_node("DrivebySoundPlayer").play()
	boss_animation_player.play("travel_right")
	boss_animation_player.advance(0)
	get_parent().has_bear_been_kidnapped = true
	remove_bear()

func remove_bear():
	$BearRemoveTimer.start()
	
	
func _on_land_on_belly():
	belly_animation_player.play("bounce")

	
func _on_bear_remove_timer_timeout():
	queue_free()


func _on_rub_area_area_entered(_area):
	is_player_overlapping = true
	evaluate_rub_state()


func _on_rub_area_area_exited(_area):
	is_player_overlapping = false
