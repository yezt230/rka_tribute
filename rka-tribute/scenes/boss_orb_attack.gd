extends Area2D

@onready var timer: Timer = $Timer
@onready var boss = get_tree().get_first_node_in_group("boss")
# Tuneable constants
#@export var gravity: float = 1200.0
@export var initial_y_velocity: float = -1000.0
@export var grav_adjustment: float = 2.0

@export var left_velocity_min := 400.0
@export var left_velocity_max := 1000.0

@export var right_velocity_min := 280.0
@export var right_velocity_max := 350.0

var velocity: Vector2
var history: Array[float] = []

func _ready() -> void:
	#DEBUG: orb attack initial velocity
	velocity = Vector2(get_next_velocity_x(), initial_y_velocity)
	print("boss orb vel: " + str(velocity))
	#velocity = Vector2(500, initial_y_velocity)
	timer.timeout.connect(on_timer_timeout)


func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += gravity * grav_adjustment * delta
	
	# Integrate position
	global_position += velocity * delta


func on_timer_timeout() -> void:
	queue_free()
	
	
func weighted_random_away(
		min_value: float,
		max_value: float,
		history: Array[float],
		strength: float = 2.0) -> float:

	if history.is_empty():
		return randf_range(min_value, max_value)

	var center := history[-1]

	if history.size() >= 2:
		center = (history[-1] + history[-2]) * 0.5

	var center_t := inverse_lerp(min_value, max_value, center)

	var t := randf()

	var dist: float = abs(t - center_t)
	var weight := pow(dist, strength)

	if t < center_t:
		t = clamp(center_t - weight, 0.0, 1.0)
	else:
		t = clamp(center_t + weight, 0.0, 1.0)

	return lerp(min_value, max_value, t)



func get_next_velocity_x() -> float:
	# Get viewport width
	var screen_width := get_viewport_rect().size.x

	# Convert boss X position into 0.0 -> 1.0
	var boss_t: float = clamp(
		boss.global_position.x / screen_width,
		0.0,
		1.0
	)

	# As boss moves right:
	# velocity ranges become smaller
	var min_vel: float = lerp(
		left_velocity_min,
		right_velocity_min,
		boss_t
	)

	var max_vel: float = lerp(
		left_velocity_max,
		right_velocity_max,
		boss_t
	)

	if boss.dir == 1:
		min_vel = max(min_vel, 400.0)

	max_vel = max(max_vel, min_vel)

	var value := weighted_random_away(
		min_vel,
		max_vel,
		history,
		2.5
	)

	history.append(value)

	if history.size() > 2:
		history.pop_front()

	return value
