extends CharacterBody2D

@onready var timer = $Timer

const GRAV_ADJUSTMENT: float = 2.0
var history: Array[float] = []

func _ready():
	var initial_velocity = Vector2(get_next_velocity_x(),-1000)
	velocity = initial_velocity
	timer.timeout.connect(on_timer_timeout)
	
	print(get_next_velocity_x())
	

func _physics_process(delta: float) -> void:
	velocity.y += (get_gravity().y * GRAV_ADJUSTMENT * delta)
	move_and_slide()
	

func on_timer_timeout():
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

	# No history → pure random
	if history.size() == 0:
		return randf_range(min_value, max_value)

	# One value → push away from it
	var center := history[-1]

	# Two values → push away from their midpoint
	if history.size() >= 2:
		center = (history[-1] + history[-2]) * 0.5

	# Normalize center to 0–1
	var center_t := inverse_lerp(min_value, max_value, center)

	# Sample uniformly in 0–1
	var t := randf()

	# Distance from center (0–1)
	var dist: float = abs(t - center_t)

	# Apply repulsion curve
	var weight := pow(dist, strength)

	# Randomly choose direction away from center
	if t < center_t:
		t = clamp(center_t - weight, 0.0, 1.0)
	else:
		t = clamp(center_t + weight, 0.0, 1.0)

	return lerp(min_value, max_value, t)
	
	
func get_next_velocity_x() -> float:
	var value = weighted_random_away(
		400.0,
		1000.0,
		history,
		2.5
	)

	history.append(value)
	if history.size() > 2:
		history.pop_front()

	return value
