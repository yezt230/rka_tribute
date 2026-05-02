extends CharacterBody2D

signal trigger_cart_cutscene

@onready var player = $"../Player"
@onready var animation_player = $WheelSprite/AnimationPlayer
@onready var cart_trigger_cutscene_hitbox: Area2D = $CartTriggerCutsceneHitbox

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
	

func _on_cart_trigger_cutscene_hitbox_area_entered(_area: Area2D) -> void:
	emit_signal("trigger_cart_cutscene")
	#if body is PlayerRubbing:
		#body.jump_onto_cart()
