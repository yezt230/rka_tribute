extends Area2D

@onready var timer: Timer = $Timer

# Tuneable constants
#@export var gravity: float = 1200.0
@export var initial_y_velocity: float = -1000.0
@export var grav_adjustment: float = 2.0

var velocity: Vector2
var history: Array[float] = []

func _ready() -> void:
	#DEBUG
	#velocity = Vector2(get_next_velocity_x(), initial_y_velocity)
	velocity = Vector2(500, initial_y_velocity)
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
	"""
    strength > 1.0  = stronger repulsion
    strength = 1.0  = linear
    strength < 1.0  = softer bias
	"""

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
	var value := weighted_random_away(
		400.0,
		1000.0,
		history,
		2.5
	)

	history.append(value)
	if history.size() > 2:
		history.pop_front()

	return value
