extends CharacterBody2D

@onready var bear_belly_platform = $"../BearBellyPlatform"
@onready var stall_timer = $"../StallTimer"
@onready var animation_player = $AnimationPlayer
@onready var shake_animation_player = $ShakeAnimationPlayer
@onready var bear_shake_tracker : int = 0
@onready var boss_animation_player = $"../Boss/AnimationPlayer"
@onready var rubbing_shake_inc_timer = $RubbingShakeIncTimer
@onready var bear_remove_timer = $BearRemoveTimer
@onready var shake_label = $ShakeLabel
@onready var has_shake_timer_started : bool = false

var is_player_overlapping := false
var is_player_rubbing := false

func _ready() -> void:
	var player = get_parent().get_node("PlayerRubbing")
	rubbing_shake_inc_timer.timeout.connect(_on_rubbing_shake_inc_timer_timeout)
	player.rubbing_started.connect(_on_player_rubbing_rubbing_started)
	player.rubbing_stopped.connect(_on_player_rubbing_rubbing_stopped)
# --- PLAYER SIGNALS ---

func _process(_delta):
	shake_label.text = str(rubbing_shake_inc_timer.time_left)


func _on_player_rubbing_rubbing_started() -> void:
	is_player_rubbing = true
	evaluate_rub_state()


func _on_player_rubbing_rubbing_stopped() -> void:
	is_player_rubbing = false
	stop_rubbing('from signal')


# --- OVERLAP DETECTION ---


# --- RUB STATE LOGIC ---

func evaluate_rub_state() -> void:
	var should_rub = is_player_overlapping and is_player_rubbing

	if should_rub and animation_player.current_animation != "rubbing1":		
		print("started")
		start_rubbing()
	#else:
		#if animation_player.current_animation != "still":
			#print("stopped")
			#stop_rubbing('from eval')


func start_rubbing() -> void:
	print('started')
	animation_player.play("rubbing1")
	if not has_shake_timer_started:
		rubbing_shake_inc_timer.start()
		has_shake_timer_started = true
	else:
		rubbing_shake_inc_timer.paused = false
	

func stop_rubbing(mystr : String) -> void:
	print("stop_rubbing" + mystr)
	animation_player.play("still")
	rubbing_shake_inc_timer.paused = true

# --- HIT / DESTROY LOGIC ---

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "RubHitbox":
		stall_timer.start()
		if bear_belly_platform:
			bear_belly_platform.queue_free()
		queue_free()


func _on_rubbing_shake_inc_timer_timeout():
	if shake_animation_player:
		match bear_shake_tracker:
			0:
				shake_animation_player.play("rub_4")
				bear_shake_tracker = 1
			1:
				shake_animation_player.play("rub_3")
				boss_animation_player.play("travel_right")
				remove_bear()
				bear_shake_tracker = 2
			2:
				shake_animation_player.play("rub_2")
				bear_shake_tracker = 3
			3:
				boss_animation_player.play("travel_right")


func remove_bear():
	bear_remove_timer.start()
	
	
func _on_bear_remove_timer_timeout():
	queue_free()


func _on_rub_area_area_entered(_area):
	is_player_overlapping = true
	evaluate_rub_state()


func _on_rub_area_area_exited(_area):
	is_player_overlapping = false
	#stop_rubbing()
