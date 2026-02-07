extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta		
	else:
		velocity.y = 0
		
	move_and_slide()
