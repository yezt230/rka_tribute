extends CharacterBody2D

const MOVE_SPEED: float = 35000
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var despawn_timer = $DespawnTimer
@onready var direction: float = -1

func _ready():
	if direction == -1.0:
		scale.x = -1


func _physics_process(delta: float) -> void:
	velocity.x = (MOVE_SPEED * direction) * delta
	move_and_slide()


func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(_area):
	despawn_timer.start()


func _on_despawn_timer_timeout():
	queue_free()
