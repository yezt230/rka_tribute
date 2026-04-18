class_name EnvironmentController
extends Node

@export var speed := 300.0

@onready var wood_scroller = $"../BG/WoodScroller"
@onready var cart = $"../Cart"
@onready var cart_animation_player = $"../Cart/WheelSprite/AnimationPlayer"
@onready var track = $"../Track"
@onready var track_animation_player = $"../Track/AnimationPlayer"

var current_direction: float = 0.0
var is_active: bool = true
var override_velocity: float = 0.0
var use_override: bool = false

func set_direction(direction: float) -> void:
	current_direction = direction

func set_active(active: bool) -> void:
	is_active = active

# --- NORMAL MOVEMENT ---
func _physics_process(_delta: float) -> void:
	if use_override:
		apply_override_motion()
		return

	if not is_active:
		stop()
		return

	var velocity_x := -(current_direction * speed)

	wood_scroller.velocity.x = velocity_x
	cart.velocity.x = velocity_x
	track.velocity.x = velocity_x

# --- CUTSCENE OVERRIDE ---
func start_cart_cutscene(velocity_x: float):
	use_override = true
	override_velocity = velocity_x
	cart_animation_player.play("rotate")

func stop_cart_cutscene():
	use_override = false
	stop()

func apply_override_motion():
	wood_scroller.velocity.x = override_velocity
	cart.velocity.x = override_velocity
	track.velocity.x = override_velocity
	#track_animation_player.play("track_loop")

func stop():
	wood_scroller.velocity.x = 0
	cart.velocity.x = 0
	track.velocity.x = 0
	
