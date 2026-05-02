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
	

# --- NORMAL MOVEMENT ---
func _physics_process(_delta: float) -> void:
	match mode:
		Mode.PLAYER_CONTROL:
			handle_player_motion()
		Mode.CUTSCENE:
			cart.velocity.x = 0
			wood_scroller.velocity.x = 0
			

func set_direction(direction: float) -> void:
	if mode != Mode.PLAYER_CONTROL:
		return

	current_direction = direction


func handle_player_motion():
	var velocity_x := -(current_direction * speed)

	wood_scroller.velocity.x = velocity_x
	cart.velocity.x = velocity_x

# --- CUTSCENE OVERRIDE ---
func start_cart_cutscene():
	mode = Mode.CUTSCENE
	track_from_single.delayed_activate_spawning()

	stop()

	var target_x = 700.0
	var duration = 2.0

	var tween = create_tween()

	tween.tween_property(cart, "global_position:x", target_x, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(wood_scroller, "global_position:x", target_x * -0.5, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

	tween.finished.connect(_on_cutscene_finished)
	cart_animation_player.play("rotate")
	

func _on_cutscene_finished():
	mode = Mode.PLAYER_CONTROL


func apply_override_motion():
	#post jumping-on-cart animation
	wood_scroller.velocity.x = override_velocity * 2.5
	cart.velocity.x = override_velocity
	if not spawned_track_yet:
		spawned_track_yet = true


func stop():
	wood_scroller.velocity.x = 0
	cart.velocity.x = 0
	

func _on_trigger_cart_cutscene():
	pass
