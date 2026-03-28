class_name PlayerRubbing extends CharacterBody2D

#collision for ground is on layer 3, orb attack is 4
signal rubbing_started
signal rubbing_stopped

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_dir: float = 1.0
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var debug_label_2 = $DebugLabel2
@onready var debug_label_3 = $DebugLabel3
@onready var state_machine = $StateMachineRubbing
@onready var idle = $StateMachineRubbing/IdleRubbing
@onready var knockback_stall_timer = $KnockbackStallTimer
@onready var current_state_name : String
@onready var rub_hitbox = $Area2D/RubHitbox
@onready var debug_label_4 = $DebugLabel2
@onready var collision_shape_2d = $CollisionShape2D
@onready var drop_down_timer = $DropDownTimer
@onready var bear_belly_collision_shape_2d = $"../BearBellyPlatform/CollisionShape2D"

var is_on_belly_platform := false
var current_floor_collider: Object = null
var is_overlapping_bear := false
var is_rubbing := false

func _ready():
	state_machine.init(self)
	

func _process(_delta):
	#print("bear overlap: " + str(is_overlapping_bear))
	current_state_name = state_machine.get_current_state()
	debug_label.text = current_state_name
	debug_label_4.text = str(is_rubbing)
	#debug_label_4.text = str(is_on_floor())
	evaluate_rub_state()
	

func _physics_process(delta: float) -> void:
	# Gravity always applies
	if not is_on_floor():
		velocity += get_gravity() * GRAV_ADJUSTMENT * delta

	# Handle jump
	if Input.is_action_just_pressed("UP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("DOWN") and is_on_floor():
		bear_belly_collision_shape_2d.disabled = true
		drop_down_timer.start()

	# Horizontal movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	get_orientation(direction)	

	rub_hitbox.position.x = 35 * player_dir

	if direction and (current_state_name != "RubStanding" and current_state_name != "IdleRubbing"):
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var jump_state = state_machine.get_node("JumpRubbing")

	if not is_on_floor():
		state_machine.change_state(jump_state)
		
	# check if on the platform specfically
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().y < 0:
			var collider = collision.get_collider()
			current_floor_collider = collider

			if collider and collider.name == "BearBellyPlatform":
				is_on_belly_platform = true
			else:
				is_on_belly_platform = false

func get_orientation(dir):
	# direction can only be -1 or 1
	if dir != 0.0:
		player_dir = dir
		player_sprite.scale.x = dir
		
		
func resolve_locomotion_state() -> State:
	# Airborne beats everything
	if not is_on_floor():
		return state_machine.get_node("JumpRubbing")

	# Horizontal input
	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
		return state_machine.get_node("RunRubbing")

	return state_machine.get_node("IdleRubbing")


#func _on_area_2d_area_entered(area):
	##take_dam
	#pass
	
func _on_area_2d_body_entered(body):
	print(body.name)
	if body.name == "BearRelaxing":
		is_overlapping_bear = true
		evaluate_rub_state()


func _on_area_2d_body_exited(body):
	print("body.nameleft")
	if body.name == "BearRelaxing":
		is_overlapping_bear = false
		stop_rubbing()


func evaluate_rub_state():
	if (is_overlapping_bear or is_on_belly_platform) and is_rubbing :
		emit_signal("rubbing_started")
	else:
		stop_rubbing()
		

func stop_rubbing():
	emit_signal("rubbing_stopped")


func _on_drop_down_timer_timeout():
	bear_belly_collision_shape_2d.disabled = false
