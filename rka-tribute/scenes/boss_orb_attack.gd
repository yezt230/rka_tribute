extends CharacterBody2D

@onready var timer = $Timer

const INITIAL_VELOCITY = Vector2(800,-1000)
const GRAV_ADJUSTMENT: float = 2.0

func _ready():
	velocity = INITIAL_VELOCITY
	timer.timeout.connect(on_timer_timeout)

func _physics_process(delta: float) -> void:
	velocity.y += (get_gravity().y * GRAV_ADJUSTMENT * delta)
	move_and_slide()

func on_timer_timeout():
	queue_free()
