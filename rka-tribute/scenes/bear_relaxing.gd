extends CharacterBody2D


@onready var bear_belly_platform = $"../BearBellyPlatform"
@onready var stall_timer = $"../StallTimer"
@onready var belly_animation_player = $AnimationPlayer
@onready var shake_animation_player = $ShakeAnimationPlayer
@onready var bear_shake_tracker : int = 0
@onready var boss_animation_player = $"../Boss/AnimationPlayer"
#DEBUG: change this node's duration to rub the bear's belly faster & proceed
@onready var rubbing_shake_inc_timer = $RubbingShakeIncTimer
@onready var bear_remove_timer = $BearRemoveTimer
@onready var shake_label = $ShakeLabel
@onready var has_shake_timer_started : bool = false
@onready var rubbing_portion = get_parent()
@onready var boss: CharacterBody2D = $"../Boss"
@onready var player_rubbing = $"../PlayerRubbing"

var is_player_overlapping := false
var is_player_rubbing := false

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
	stop_rubbing('from signal')
	

func evaluate_rub_state() -> void:
	var should_rub = is_player_overlapping and is_player_rubbing

	if should_rub \
	and belly_animation_player.current_animation != "rubbing1" \
	and belly_animation_player.current_animation != "rubbing2":		
		start_rubbing()


func start_rubbing() -> void:
	var anim_to_play = "rubbing2" if player_rubbing.is_on_belly_platform else "rubbing1"
	belly_animation_player.play(anim_to_play)
	if not has_shake_timer_started:
		rubbing_shake_inc_timer.start()
		has_shake_timer_started = true
	else:
		rubbing_shake_inc_timer.paused = false
	

func stop_rubbing(mystr : String) -> void:
	belly_animation_player.play("still")
	rubbing_shake_inc_timer.paused = true

# --- HIT / DESTROY LOGIC ---

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "RubHitbox":
		stall_timer.start()
		if bear_belly_platform:
			bear_belly_platform.queue_free()
		queue_free()


func _on_rubbing_shake_inc_timer_timeout():
	#pass
	#DEBUG: bear belly rubbing shake escalation
	if shake_animation_player:
		match bear_shake_tracker:
			0:
				shake_animation_player.play("rub_5")
				bear_shake_tracker = 1
			#1:
				#shake_animation_player.play("rub_4")
				#player_rubbing.get_node("ShakeAnimationPlayer").play("shake")
				#bear_shake_tracker = 2
			#2:
				#shake_animation_player.play("rub_3")
				#bear_shake_tracker = 3
			#3:
				#spawn_and_move_train()
				#player_rubbing.get_node("ShakeAnimationPlayer").play("still")
				#boss_animation_player.play("travel_right")


func spawn_and_move_train():
	boss.modulate.a = 100
	boss_animation_player.play("travel_right")
	rubbing_portion.has_bear_been_kidnapped = true
	remove_bear()

func remove_bear():
	bear_remove_timer.start()
	
	
func _on_land_on_belly():
	print("ka")
	belly_animation_player.play("bounce")

	
func _on_bear_remove_timer_timeout():
	queue_free()


func _on_rub_area_area_entered(_area):
	is_player_overlapping = true
	evaluate_rub_state()


func _on_rub_area_area_exited(_area):
	is_player_overlapping = false
	#stop_rubbing()
