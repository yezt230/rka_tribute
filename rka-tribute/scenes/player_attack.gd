extends CharacterBody2D

const MOVE_SPEED: float = 35000
@onready var direction: float

func _ready():
	#direction
	pass


func _physics_process(delta: float) -> void:
	velocity.x = (MOVE_SPEED * direction) * delta
	move_and_slide()


func _on_timer_timeout():
	queue_free()
