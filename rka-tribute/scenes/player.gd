extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_dir: float = 1.0
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * GRAV_ADJUSTMENT * delta

	# Handle jump.
	if Input.is_action_just_pressed("UP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("LEFT", "RIGHT")
	get_orientation(direction)	

	if direction:
		velocity.x = direction * SPEED
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_player.play("idle")

	#animation handling section
	if velocity.y != 0:
		if velocity.y < -400:
			player_sprite.frame = 11
		elif velocity.y > 400:
			player_sprite.frame = 9
		else:
			player_sprite.frame = 10
	elif direction:
		animation_player.play("run")
	else:
		animation_player.play("idle")

	move_and_slide()


func get_orientation(dir):
	# direction can only be -1 or 1
	if dir != 0.0:
		player_dir = dir
		player_sprite.scale.x = dir
