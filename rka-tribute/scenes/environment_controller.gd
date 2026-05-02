class_name EnvironmentController
extends Node

@export var speed := 300.0

@onready var wood_scroller = $"../BG/WoodScroller"
@onready var cart = $"../Cart"
@onready var cart_animation_player = $"../Cart/WheelSprite/AnimationPlayer"
#@onready var track = $"../Track"
#@onready var track_animation_player = $"../Track/AnimationPlayer"
@onready var track_from_single = $"../TrackFromSingle"

var current_direction: float = 0.0
enum Mode {
	PLAYER_CONTROL,
	CUTSCENE
}
var mode: Mode = Mode.PLAYER_CONTROL
var override_velocity: float = 0.0
var spawned_track_yet : bool = false

func _ready():
	cart.trigger_cart_cutscene.connect(self._on_trigger_cart_cutscene)


func set_direction(direction: float) -> void:
	current_direction = direction


#func set_active(active: bool) -> void:
	#is_active = active

# --- NORMAL MOVEMENT ---
func _physics_process(_delta: float) -> void:
	match mode:
		Mode.PLAYER_CONTROL:
			handle_player_motion()
		Mode.CUTSCENE:
			pass # do nothing here

	var velocity_x := -(current_direction * speed)

	wood_scroller.velocity.x = velocity_x
	cart.velocity.x = velocity_x
	#track.velocity.x = velocity_x


func handle_player_motion():
	var velocity_x := -(current_direction * speed)

	wood_scroller.velocity.x = velocity_x
	cart.velocity.x = velocity_x

# --- CUTSCENE OVERRIDE ---
func start_cart_cutscene():
	mode = Mode.CUTSCENE

	# stop all physics-driven motion
	stop()

	var target_x = 500 # whatever your "onscreen" position is

	var tween = create_tween()
	tween.tween_property(cart, "global_position:x", target_x, 1.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(wood_scroller, "global_position:x", target_x * -0.5, 1.2)

	tween.finished.connect(_on_cutscene_finished)

	cart_animation_player.play("rotate")

#
#func stop_cart_cutscene():
	#use_override = false
	#stop()

func _on_cutscene_finished():
	mode = Mode.PLAYER_CONTROL



func apply_override_motion():
	#post jumping-on-cart animation
	wood_scroller.velocity.x = override_velocity * 2.5
	cart.velocity.x = override_velocity
	if not spawned_track_yet:
		#track_from_single.spawn_rubbing_segments()
		spawned_track_yet = true
	#track.velocity.x = override_velocity
	#track_animation_player.play("track_loop")

func stop():
	wood_scroller.velocity.x = 0
	cart.velocity.x = 0
	#track.velocity.x = 0
	

func _on_trigger_cart_cutscene():
	print("env hit")
