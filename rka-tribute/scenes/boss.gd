extends CharacterBody2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta
		
	else:
		velocity.y = 0
		print("velocity.ycontact")
	move_and_slide()

func _on_area_2d_body_entered():
	pass
