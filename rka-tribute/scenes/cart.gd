extends CharacterBody2D

@onready var player = $"../Player"
@onready var animation_player = $WheelSprite/AnimationPlayer

func _ready():
#	checks if player is in the tree as opposed to
# playerRubbing; if playerRubbing, then it's the
# rubbing portion and the cart will start out stationary
	if not player:
		animation_player.play("static")	
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta		
	else:
		velocity.y = 0
	if player:
		global_position.x = player.position.x	
	move_and_slide()
