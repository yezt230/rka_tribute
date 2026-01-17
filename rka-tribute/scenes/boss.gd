extends CharacterBody2D

@onready var coupling_rod_orbit = $CouplingRodOrbit
@onready var coupling_rod_sprite = $CouplingRodOrbit/CouplingRodSprite

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta
		
	else:
		velocity.y = 0
		print("velocity.ycontact")
		
	coupling_rod_orbit.rotation += 7.5 * delta
	coupling_rod_sprite.rotation = -coupling_rod_orbit.rotation
		
	move_and_slide()

func _on_area_2d_body_entered():
	pass
