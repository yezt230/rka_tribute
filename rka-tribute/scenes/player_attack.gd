extends CharacterBody2D

const MOVE_SPEED: float = 35000
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var direction: float

func _ready():
	print(str(direction))
	if direction == -1.0:
		scale.x = -1


func _physics_process(delta: float) -> void:
	velocity.x = (MOVE_SPEED * direction) * delta
	move_and_slide()


func _on_timer_timeout():
	queue_free()
